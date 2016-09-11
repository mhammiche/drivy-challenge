class Action < Struct.new(:who, :type, :amount)
  def delta(updated)
    if who != updated.who || type != updated.type
      raise ArgumentError, "actions must be of the same owner and type"
    end

    amount_delta = updated.amount - amount

    if amount_delta < 0
      amount_delta = -amount_delta
      new_type = type == "debit" ? "credit" : "debit"
    else
      new_type = type
    end

    Action.new(who, new_type, amount_delta)
  end
end
