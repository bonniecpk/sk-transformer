require_relative '../spec_helper'

module ShopKeep
  describe TransformerFactory do
    context "#get_transformer" do
      it "get csv transformer" do
        expect(TransformerFactory.get_transformer(TransformerFactory::TYPES[:csv]).class).to \
          eq(CSVTransformer)
      end

      it "get NotImplementedError" do
        expect{ TransformerFactory.get_transformer("adsfadsf") }.to raise_error(NotImplementedError)
      end
    end
  end
end
