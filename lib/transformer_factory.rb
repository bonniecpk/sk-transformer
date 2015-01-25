module ShopKeep
  class InvalidTransformerType < StandardError; end

  class TransformerFactory
    TYPES = {
      csv: 'csv'
    }

    def self.get_transformer(type, opts = {})
      case type
      when TYPES[:csv] then CSVTransformer.new(opts)
      else raise InvalidTransformerType.new("#{type} is invalid. Please choose the types from: #{TYPES.join(', ')}")
      end
    end
  end
end
