require_relative './spec_helper'

describe ShopKeep::Transformer do
 let(:data_dir) { "#{File.dirname(__FILE__)}/data" }

 context "#transform" do
   it "missing headers" do
     expect { ShopKeep::Transformer.new(
       input: "#{data_dir}/no_header.csv"
     ).transform }.to raise_error(ShopKeep::InvalidFormat)
   end

   it "missing data" do
     expect { ShopKeep::Transformer.new(
       input: "#{data_dir}/no_data.csv"
     ).transform }.to raise_error(ShopKeep::InvalidFormat)
   end

   it "all valid columns" do
     expect(ShopKeep::Transformer.new(
       input: "#{data_dir}/valid.csv"
     ).transform.to_json).to eq(File.read("#{data_dir}/valid.json"))
   end
 end

 context "#_clean" do
   class DummyTransformer < ShopKeep::Transformer
     def self.clean(hash)
       _clean(hash)
     end
   end

   it "with item_id" do
     expect(DummyTransformer.clean({item_id: "1"})).to eq({id: 1})
   end

   it "with quantity_on_hand" do
     expect(DummyTransformer.clean({quantity_on_hand: "123"})).to eq({quantity_on_hand: 123})
   end

   it "with modifiers" do
     expect(DummyTransformer.clean({
       modifier_1_name: "large",
       modifier_1_price: "$324"})).to eq({modifier_1_name: "large", modifier_1_price: 324})
   end

   it "with positive price" do
     expect(DummyTransformer.clean({price: "$123"})).to eq({price: 123})
   end

   it "with negative price" do
     expect(DummyTransformer.clean({price: "-$123"})).to eq({price: -123})
   end

   it "with price with decimal and without $" do
     expect(DummyTransformer.clean({price: "123.34"})).to eq({price: 123.34})
   end
 end
end
