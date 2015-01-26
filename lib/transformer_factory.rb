module ShopKeep
  class TransformerFactory
    TYPES = {
      csv: 'csv'
    }

    def self.get_transformer(type, opts = {})
      case type
      when TYPES[:csv] then CSVTransformer.new(opts)
      else raise NotImplementedError.new("#{type} is invalid. Please choose the types from: #{TYPES.values.join(', ')}")
      end
    end
  end
end
