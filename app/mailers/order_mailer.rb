class OrderMailer < ApplicationMailer
  
  def completed(order)
    mail to: order.user.email, subject: "Deal Order Successfully Completed"
  end

  def cancelled(order)
    mail to: order.user.email, subject: "Deal Order Cancelled"
  end
end