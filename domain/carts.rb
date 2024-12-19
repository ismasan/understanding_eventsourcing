module Carts
  # Cart commands
  AddItem = Sourced::Command.define('carts.add_item') do
    attribute :item_id, Sourced::Types::AutoUUID
    attribute :product_id, Sourced::Types::UUID::V4
    attribute :description, String
    attribute :image, String
    attribute :price, Sourced::Types::Lax::Integer
    attribute :total_price, Sourced::Types::Lax::Integer
  end

  # Cart events
  CartStarted = Sourced::Event.define('carts.started')

  ItemAdded = Sourced::Event.define('carts.item_added') do
    attribute :item_id, Sourced::Types::UUID::V4
    attribute :product_id, Sourced::Types::UUID::V4
    attribute :description, String
    attribute :image, String
    attribute :price, Sourced::Types::Lax::Integer
    attribute :total_price, Sourced::Types::Lax::Integer
  end
end
