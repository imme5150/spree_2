object :variant
attributes *Spree::Api::ApiHelpers.variant_attributes

extends "spree/api/variants/small"

child(:stock_items => :stock_items) do
  attributes :id, :count_on_hand, :stock_location_id, :backorderable
  attribute :available? => :available

  glue(:stock_location) do
    attribute :name => :stock_location_name
  end
end
