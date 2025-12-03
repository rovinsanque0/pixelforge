class Orders::CreateFromStripeService
  def initialize(user, cart)
    @user = user
    @cart = cart
  end

  def call
    province = @user.province
    subtotal = calculate_subtotal
    gst      = subtotal * province.gst
    pst      = subtotal * province.pst
    hst      = subtotal * province.hst
    total    = subtotal + gst + pst + hst

    order = Order.create!(
      user: @user,
      province: province,
      status: "paid",
      subtotal: subtotal,
      gst_amount: gst,
      pst_amount: pst,
      hst_amount: hst,
      total: total,
      stripe_payment_id: SecureRandom.hex(10)
    )

    @cart.each do |pid, qty|
      product = Product.find(pid)
      order.order_items.create!(
        product: product,
        quantity: qty,
        price_at_purchase: product.display_price
      )
    end

    order
  end

  def calculate_subtotal
    @cart.sum do |pid, qty|
      product = Product.find(pid)
      product.display_price * qty.to_i
    end
  end
end
