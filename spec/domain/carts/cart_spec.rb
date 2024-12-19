require 'spec_helper'

RSpec.describe Carts::Cart do
  describe Carts::AddItem do
    it 'adds a line item' do
      stream_id = 'cart-1'

      cart = Carts::Cart.new(stream_id)

      # When
      cmd = build_message(
        Carts::AddItem,
        stream_id,
        product_id: SecureRandom.uuid,
        description: 'A product',
        image: 'http://example.com/image.jpg',
        price: 2000,
        total_price: 2100
      )

      _state, events = cart.decide(cmd)
      # Then

      # Sourced includes initial command in returned events
      expected_events = [
        cmd,
        Carts::CartStarted.parse(stream_id:),
        Carts::ItemAdded.parse(stream_id:, payload: cmd.payload.to_h)
      ]

      assert_same_events(expected_events, events)
    end

    it 'supports up to 3 items' do
      cart = Carts::Cart.new('cart-1')

      cart.event(
        Carts::ItemAdded, 
        product_id: SecureRandom.uuid,
        item_id: SecureRandom.uuid,
        description: 'p1',
        image: 'http://example.com/1.jpg',
        price: 2000,
        total_price: 2100
      )
      cart.event(
        Carts::ItemAdded, 
        product_id: SecureRandom.uuid,
        item_id: SecureRandom.uuid,
        description: 'p2',
        image: 'http://example.com/2.jpg',
        price: 2000,
        total_price: 2100
      )
      cart.event(
        Carts::ItemAdded, 
        product_id: SecureRandom.uuid,
        item_id: SecureRandom.uuid,
        description: 'p3',
        image: 'http://example.com/3.jpg',
        price: 2000,
        total_price: 2100
      )

      expect do
        cart.decide build_message(
          Carts::AddItem, 
          cart.id,
          product_id: SecureRandom.uuid,
          description: 'p3',
          image: 'http://example.com/1.jpg',
          price: 2000,
          total_price: 2100
        )
      end.to raise_error(Carts::Cart::MaxItemsReachedError, 'can only add up to 3 items')
    end
  end

  private

  def build_message(message_class, stream_id, payload = {})
    message_class.parse(stream_id:, payload:)
  end

  def assert_same_events(expected, actual)
    expect(actual.map(&:payload)).to eq(expected.map(&:payload))
  end
end
