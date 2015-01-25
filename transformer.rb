require 'optparse'
require 'ostruct'
require 'csv'
require 'json'
require 'money'

module ShopKeep
  class Transformer
    def initialize(opts = {})
      @input  = opts[:input]
      @output = opts[:output]
      
      output_dir = File.dirname(@output)
      FileUtil.mk_p(output_dir) unless File.exists? output_dir
    end

    def transform
      output = []
      CSV.foreach(@input, headers: true, header_converters: :symbol) do |row|
        output << _clean(Hash[row.headers[0..-1].zip(row.fields[0..-1])])
      end

      File.open(@output, 'w') { |file| file.write(JSON.pretty_generate(output)) }
    end

    private
    def _clean(hash)
      Hash[hash.collect do |key, val|
        case key
        when "item_id" 
          then [:id, val.to_i]
        when "price"
        when "cost"
          then [key.to_sym, Money.parse(val)]
        when "quantity_on_hand" 
          then [key.to_sym, val.to_i]
        else [key.to_sym, val]
        end
      end]
    end
  end
end

$options = OpenStruct.new

optparser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{__FILE__} -i /path/to/input -o /path/to/output"

  opts.on('-i', '--input=', 'Input file path') do |i|
    $options.input = i
  end

  opts.on('-o', '--output=', 'Output file path') do |o|
    $options.output = o
  end
end

optparser.parse!

unless $options.input && $options.output
  puts optparser.help
end

ShopKeep::Transformer.new(
  input:  $options.input,
  output: $options.output,
).transform
