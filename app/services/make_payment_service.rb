class MakePaymentService

  def perform(order)

    if !order.stripe_token.present?
      order.errors[:base] << 'Could not verify card.'
      return false
      #raise ActiveRecord::RecordInvalid.new(order)
    end

    customer = create_customer(order)
    charge = create_charge(customer, order)
    order.stripe_token = nil

    Rails.logger.info("Stripe transaction for #{order.user_id}") if charge[:paid] == true
  rescue Stripe::InvalidRequestError => e
    order.errors[:base] << e.message
    order.stripe_token = nil
    return false
    #raise ActiveRecord::RecordInvalid.new(order)
  rescue Stripe::CardError => e
    order.errors[:base] << e.message
    order.stripe_token = nil
    return false
    #raise ActiveRecord::RecordInvalid.new(order)
  end

  def create_customer(order)
    user = order.get_user
    customer = Stripe::Customer.create(
    :email => user.email,
    :card => order.stripe_token
    )
  end

  def create_charge(customer, order)

    price = (order.total * 100).round
    title = order.id
    charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => "#{price}",
    :description => "#{title}",
    :currency    => 'usd'
    )
  end

end
