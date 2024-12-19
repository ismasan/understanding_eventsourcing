require 'spec_helper'

RSpec.describe Carts::Cart do
  describe Carts::AddItem do
    it 'adds a line item' do
      stream_id = 'cart-1'
      product_id = SecureRandom.uuid

      cart = Carts::Cart.new(stream_id)

      # When
      cmd = build_message(
        Carts::AddItem,
        stream_id,
        product_id:,
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
  end

  private

  def build_message(message_class, stream_id, payload = {})
    message_class.parse(stream_id:, payload:)
  end

  def assert_same_events(expected, actual)
    expect(actual.map(&:payload)).to eq(expected.map(&:payload))
  end
end
