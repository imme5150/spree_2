object @adjustment
attributes *Spree::Api::ApiHelpers.adjustment_attributes
node(:display_amount) { |a| a.display_amount.to_s }
