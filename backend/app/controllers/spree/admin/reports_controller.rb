module Spree
  module Admin
    class ReportsController < Spree::Admin::BaseController
      respond_to :html

      class << self
        def available_reports
          @@available_reports
        end

        def add_available_report!(report_key, report_description_key = nil)
          if report_description_key.nil?
            report_description_key = "#{report_key}_description"
          end
          @@available_reports[report_key] = {name: Spree.t(report_key), description: Spree.t(report_description_key)}
        end
      end

      def index
        @reports = ReportsController.available_reports
      end

      private
      def model_class
        Spree::Admin::ReportsController
      end

      @@available_reports = {}
    end
  end
end
