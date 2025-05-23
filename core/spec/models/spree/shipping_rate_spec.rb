# encoding: utf-8

require 'spec_helper'

describe Spree::ShippingRate do
  let(:shipment) { create(:shipment) }
  let(:shipping_method) { create(:shipping_method) }
  let(:shipping_rate) { Spree::ShippingRate.new(:shipment => shipment,
                                                :shipping_method => shipping_method,
                                                :cost => 10) }

  context "#display_price" do
    context "when tax included in price" do
      context "when the tax rate is from the default zone" do
        let!(:zone) { create(:zone, :default_tax => true) }
        let(:tax_rate) do 
          create(:tax_rate,
            :name => "VAT",
            :amount => 0.1,
            :included_in_price => true,
            :zone => zone)
        end

        before { shipping_rate.tax_rate = tax_rate }

        it "shows correct tax amount" do
          expect(shipping_rate.display_price.to_s).to eq("$10.00 (incl. $0.91 #{tax_rate.name})")
        end
      end

      context "when the tax rate is from a non-default zone" do
        let!(:default_zone) { create(:zone, :default_tax => true) }
        let!(:non_default_zone) { create(:zone, :default_tax => false) }
        let(:tax_rate) do
          create(:tax_rate,
            :name => "VAT",
            :amount => 0.1,
            :included_in_price => true,
            :zone => non_default_zone)
        end
        before { shipping_rate.tax_rate = tax_rate }

        it "shows correct tax amount" do
          expect(shipping_rate.display_price.to_s).to eq("$10.00 (excl. $0.91 #{tax_rate.name})")
        end
      end
    end

    context "when tax is additional to price" do
      let(:tax_rate) { create(:tax_rate, :name => "Sales Tax", :amount => 0.1) }
      before { shipping_rate.tax_rate = tax_rate }

      it "shows correct tax amount" do
        expect(shipping_rate.display_price.to_s).to eq("$10.00 (+ $1.00 #{tax_rate.name})")
      end
    end

    context "when the currency is JPY" do
      let(:shipping_rate) { shipping_rate = Spree::ShippingRate.new(:cost => 205)
                            shipping_rate.stub(:currency => "JPY")
                            shipping_rate }

      it "displays the price in yen" do
        shipping_rate.display_price.to_s.should == "¥205"
      end
    end
  end

  # Regression test for #3829
  context "#shipping_method" do
    it "can be retrieved" do
      expect(shipping_rate.shipping_method.reload).to eq(shipping_method)
    end

    it "can be retrieved even when deleted" do
      shipping_method.update_column(:deleted_at, Time.now)
      shipping_rate.save
      shipping_rate.reload
      expect(shipping_rate.shipping_method).to eq(shipping_method)
    end
  end

  context "#tax_rate" do
    let!(:tax_rate) { create(:tax_rate) }

    before do
      shipping_rate.tax_rate = tax_rate
    end

    it "can be retrieved" do
      expect(shipping_rate.tax_rate.reload).to eq(tax_rate)
    end

    it "can be retrieved even when deleted" do
      tax_rate.update_column(:deleted_at, Time.now)
      shipping_rate.save
      shipping_rate.reload
      expect(shipping_rate.tax_rate).to eq(tax_rate)
    end
  end
end
