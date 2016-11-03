class BulkOrderController < ApplicationController

  def new
    @bulk_order = BulkOrder.new
  end

  def show
    @email_sent = params[:email_sent] if params.has_key?('email_sent')
  end

  def create
    Rails.logger.info "in create params is #{params}"
    bulk_order = BulkOrder.new
    bulk_order.promo_code = SecureRandom.hex(4).upcase
    Rails.logger.info "after promo code"
    bulk_order.selected_plan = params[:bulk_order][:selected_plan].to_i
    bulk_order.user_email = params[:bulk_order][:user_email]
    Rails.logger.info "after selected plan"
    message = "We have received payment for your bulk order. Please use promo code #{bulk_order.promo_code}"
    subject = "Promo Code"
    #PAYMENT_PLAN[params[:bulk_order][:selected_plan].to_i-1]
    case params[:appraisal_credits]
      when "1"
        bulk_order.credits_count = 3
        bulk_order.credits_remaining = 3
        bulk_order.discount = 10
      when "2"
        bulk_order.credits_count = 5
        bulk_order.credits_remaining = 5
        bulk_order.discount = 15
      when "3"
        bulk_order.credits_count = 10
        bulk_order.credits_remaining = 5
        bulk_order.discount = 20
      else

    end
    bulk_order.save

    UserMailer.bulk_order_code(params[:bulk_order][:user_email], message, subject, bulk_order.promo_code).deliver_now
    Rails.logger.info "in create params is #{params}"
  end

  def resend_code
    user = User.find_by_email(params[:email])
    if user.valid_password?(params[:password])
      email_code(params[:email])
      @email_sent = "An email has been sent with all details related to your bulk orders"
    else
      @email_sent = "Invalid user name or password"
    end
    redirect_to :controller => "bulk_order", :action => :show, :email_sent => @email_sent
  end

  def email_code email
    bulk_orders = BulkOrder.where(user_email: email)
    message = "Please find below all details related to your bulk orders:"
    subject = "Bulk Orders"
    UserMailer.resend_bulk_order_code(email, message, subject, bulk_orders).deliver_now
  end


end