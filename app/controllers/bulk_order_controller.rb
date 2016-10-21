class BulkOrderController < ApplicationController

  def new
    @bulk_order = BulkOrder.new
  end

  def create
    Rails.logger.info "in create params is #{params}"
    bulk_order = BulkOrder.new
    bulk_order.promo_code = SecureRandom.hex(4).upcase
    Rails.logger.info "after promo code"
    bulk_order.selected_plan = params[:bulk_order][:selected_plan].to_i
    bulk_order.user_email = params[:user_email]
    Rails.logger.info "after selected plan"
    message = "We have received payment for your bulk order. Please use promo code #{bulk_order.promo_code}"
    subject = "Promo Code"
    #PAYMENT_PLAN[params[:bulk_order][:selected_plan].to_i-1]
    case params[:appraisal_credits]
      when "1"
        bulk_order.credits_count = 3
        bulk_order.discount = 10
      when "2"
        bulk_order.credits_count = 5
        bulk_order.discount = 15
      when "3"
        bulk_order.credits_count = 10
        bulk_order.discount = 20
      else

    end
    bulk_order.save

    UserMailer.bulk_order_code(params[:user_email], message, subject, bulk_order.promo_code).deliver_now
    Rails.logger.info "in create params is #{params}"
  end
end