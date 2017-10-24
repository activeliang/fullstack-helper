module OrdersHelper

  def render_order_paid_state(order)
    if order.is_paid?
      "(已付款)"
    else
      "(未付款)"
    end
  end

  def render_order_status(order)
    case order.aasm_state
    when 'order_placed'
      "未付款"
    when 'paid'
      "等待发货"
    when 'shipping'
      "已发货"
    when 'shipped'
      "已完成"
    when 'order_cancelled'
      "订单已关闭"
    when 'good_returned'
      "已退货"
    end
  end
end
