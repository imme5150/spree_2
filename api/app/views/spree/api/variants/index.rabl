object false
node(:count) { @variants.count }
node(:total_count) { @variants.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }

child(:@variants) do
  attributes :id, :sku
  node :text do |v|
    "#{v.sku}: #{v.name} - #{v.options_text}"
  end
end

