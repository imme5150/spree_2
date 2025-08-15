cache @order
attributes *order_attributes
node(:display_item_total) { |o| o.item_total }
node(:total_quantity) { |o| o.line_items.sum(:quantity) }
node(:display_total) { |o| o.total }
node(:display_ship_total) { |o| o.shipment_total }
node(:token) { |o| o.token }
node(:checkout_steps) { |o| o.checkout_steps }
