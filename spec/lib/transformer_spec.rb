require_relative '../spec_helper'

module ShopKeep
  describe Transformer do
    context "#_clean" do
      class DummyTransformer < Transformer
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
          modifier_1_price: "$324"
        })).to eq({modifier_1_name: "large", modifier_1_price: 324})
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

    context "#_format_modifiers" do
      class DummyTransformer < ShopKeep::Transformer
        def self.format(hash)
          _format_modifiers(hash)
        end
      end

      it "one modifier" do
        expect(DummyTransformer.format({
          modifier_1_name: 'large', 
          modifier_1_price: 324
        })).to eq({modifiers: [{name: 'large', price: 324}]})
      end

      it "multiple modifiers" do
        expect(DummyTransformer.format({
          modifier_1_name: 'large', 
          modifier_1_price: 324,
          modifier_10_name: 'Medium', 
          modifier_10_price: 1.0
        })).to eq({
          modifiers: [
            {name: 'large', price: 324}, 
            {name: 'Medium', price: 1.0}
        ]
        })
      end

      it "modifiers with extra data" do
        expect(DummyTransformer.format({
          id: 1234,
          description: 'product A',
          modifier_1_name: 'large', 
          modifier_1_price: 324,
          modifier_10_name: 'Medium', 
          modifier_10_price: 1.0
        })).to eq({
          id: 1234,
          description: 'product A',
          modifiers: [
            {name: 'large', price: 324}, 
            {name: 'Medium', price: 1.0}
        ]
        })
      end
    end
  end


  describe CSVTransformer do
    let(:data_dir) { "#{File.dirname(__FILE__)}/../data" }

    context "#transform" do
      it "missing headers" do
        expect { 
          CSVTransformer.new(input: "#{data_dir}/no_header.csv").transform
        }.to raise_error(InvalidFormat)
      end

      it "missing data" do
        expect { 
          CSVTransformer.new(input: "#{data_dir}/no_data.csv").transform
        }.to raise_error(InvalidFormat)
      end

      it "all valid columns" do
        expect(
          CSVTransformer.new(input: "#{data_dir}/valid.csv").transform.to_json
        ).to eq(File.read("#{data_dir}/valid.json"))
      end
    end
  end
end
