require 'i18n'
require 'active_support/core_ext/array/extract_options'
require 'spree/i18n/base'

module Spree
  extend ActionView::Helpers::TranslationHelper
  extend ActionView::Helpers::TagHelper

  class << self
    # Add spree namespace and delegate to Rails TranslationHelper for some nice
    # extra functionality. e.g return reasonable strings for missing translations
    def translate(key, **options)
      @virtual_path = virtual_path

      options[:scope] = [*options[:scope]].unshift(:spree)
      super(key, **options)
    end

    alias_method :t, :translate

    def context
      Spree::ViewContext.context
    end

    def virtual_path
      if context
        path = context.instance_variable_get("@virtual_path")

        if path
          path.gsub(/spree/, '')
        end
      end
    end
  end
end
