# Spree's rpsec controller tests get the Spree::ControllerHacks
# we don't need those for the anonymous controller here, so
# we call process directly instead of get
require 'spec_helper'

describe Spree::Admin::BaseController do
  controller(Spree::Admin::BaseController) do
    def index
      authorize! :update, Spree::Order
      render :text => 'test'
    end
  end

  context "unauthorized request" do
    before do
      Spree::Admin::BaseController.any_instance.stub(:spree_current_user).and_return(nil)
    end

    it "checks error" do
      controller.stub root_path: "/rooot"
      get :index
      expect(response).to redirect_to "/rooot"
    end
  end

  describe "check alerts" do
    stub_authorization!

    it "checks alerts with before_action" do
      controller.should_receive :check_alerts
      process :index
    end

    it "saves alerts into session" do
      controller.stub(:should_check_alerts? => true)
      Spree::Alert.should_receive(:current).and_return([{"id" => "1", "message" => "test alert", "severity" => 'release'}])
      process :index
      session[:alerts].first["message"].should eq "test alert"
    end

    describe "should_check_alerts?" do
      before do
        Rails.env.stub(:production? => true)
        Spree::Config[:check_for_spree_alerts] = true
        Spree::Config[:last_check_for_spree_alerts] = nil
      end

      it "only checks alerts if production and preference is true" do
        controller.send(:should_check_alerts?).should be_true
      end

      it "only checks for production" do
        Rails.env.stub(:production? => false)
        controller.send(:should_check_alerts?).should be_false
      end

      it "only checks if preference is true" do
        Spree::Config[:check_for_spree_alerts] = false
        controller.send(:should_check_alerts?).should be_false
      end
    end
  end
end
