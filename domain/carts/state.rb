module Carts
  # This class encapsulates the state of a shopping cart,
  # including line items.
  class State
    attr_reader :id, :line_items
    attr_accessor :status, :seq, :updated_at

    # A Struct to represent a line item in the cart.
    LineItem = Struct.new(
      :item_id, 
      :product_id, 
      :description, 
      :image, 
      :price, 
      :total_price, 
      keyword_init: true
    )

    def initialize(id)
      @id = id
      @seq = 0
      @updated_at = nil
      @status = :new
      @line_items = {}
    end

    # @param [Hash] item attrs
    # @return [LineItem]
    def add_item(item_id:, **attrs)
      line_items[item_id] = LineItem.new(item_id:, **attrs)
    end

    # @return [Numeric]
    def total
      line_items.values.sum(&:total)
    end
  end
end
