module Carts
  # The Shopping cart "Decider" encapsulates
  # command handlers and event projections to manage the state of a shopping cart.
  class Cart < Sourced::Decider
    MAX_ITEMS = 3

    MaxItemsReachedError = Class.new(StandardError)

    # The initial state
    state do |id|
      State.new(id)
    end

    command AddItem do |cart, cmd|
      raise MaxItemsReachedError, 'can only add up to 3 items' if cart.line_items.size >= MAX_ITEMS

      event CartStarted if cart.status == :new

      event ItemAdded, cmd.payload
    end

    event CartStarted do |cart, _event|
      cart.status = :started
    end

    event ItemAdded do |cart, event|
      cart.add_item(**event.payload.to_h)
    end
  end
end
