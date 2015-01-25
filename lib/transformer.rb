module ShopKeep
  class InvalidFormat < StandardError; end

  ###---------------------------------------------------------------------------###
  # This transformer assumes:
  # - all columns have a rigid ordering
  #
  # If we have other input formats, the subclass can inherit Transformer and
  # modify the transform method.
  ###---------------------------------------------------------------------------###
  class Transformer
    HEADERS = [
      :item_id,
      :description,
      :price,
      :cost,
      :price_type,
      :quantity_on_hand
    ]

    def initialize(opts = {})
      @input  = opts[:input]

      if opts[:output]
        @output = opts[:output]
        output_dir = File.dirname(@output)
        FileUtil.mk_p(output_dir) unless File.exists? output_dir
      end
    end

    def transform
      @formatted = []
      CSV.foreach(@input, headers: true, header_converters: :symbol) do |row|
        raise InvalidFormat.new("Missing headers: #{HEADERS.join(', ')}...") unless row.headers[0..5] == HEADERS
        @formatted << Transformer::_clean(Hash[row.headers[0..-1].zip(row.fields[0..-1])])
      end

      raise InvalidFormat.new("#{@input} has no data") if @formatted.size == 0

      self
    end

    def to_json
      JSON.pretty_generate(@formatted)
    end

    def to_file
      File.open(@output, 'w') { |file| file.write(self.to_json) }
    end

    protected
    class << self
      def _clean(hash)
        Hash[hash.collect do |key, val|
          case key
          when :item_id
            [:id, _format(val)]
          else 
            val.nil? ? nil : [key, _format(val)]
          end
        end.compact]
      end

      def _format(val)
        if /\$/ =~ val
          Monetize.parse(val).to_f
        elsif /[0-9]+\.[0-9]+/ =~ val
          val.to_f
        elsif /[0-9]+/ =~ val
          val.to_i
        else
          val
        end
      end
    end
  end
end

