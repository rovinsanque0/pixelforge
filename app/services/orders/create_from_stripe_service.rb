class Orders::CreateFromStripeService
  def initialize(user, cart, session_data)
    @user = user
    @cart = cart
    @session_data = session_data
  end

  def call
    province = Province.find(@session_data[:checkout_province_id])

    subtotal = calculate_subtotal
    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst

    order = Order.create!(
      user: @user,
      province: province,
      address: @session_data[:checkout_address],
      city: @session_data[:checkout_city],
      postal_code: @session_data[:checkout_postal_code],
      status: "paid",
      subtotal: subtotal,
      gst_amount: gst,
      pst_amount: pst,
      hst_amount: hst,
      total: total
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

  private

  def calculate_subtotal
    @cart.sum do |pid, qty|
      product = Product.find(pid)
      product.display_price * qty.to_i
    end
  end
end
