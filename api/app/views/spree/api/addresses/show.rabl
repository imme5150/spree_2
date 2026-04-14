object @address
attributes *Spree::Api::ApiHelpers.address_attributes

child(:country) do |address|
  attributes *Spree::Api::ApiHelpers.country_attributes
end
child(:state) do |address|
  attributes *Spree::Api::ApiHelpers.state_attributes
end
