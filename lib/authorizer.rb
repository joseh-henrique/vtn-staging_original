module Authorizer
  class Authorizenet
    def process(params)
      validation_result = validate(appraisal: params[:appraisal], appraisal_params: params[:params])
      return validation_result if validation_result[:status] == false
      charge(params[:appraisal], params[:params])
    end

    def process_bulk_order(params)
      charge_bulk_order(params)
    end

    # private
    def charge_bulk_order(params)
      result = Hash[:status => false, :message => ""]
      gateway = get_gateway
      request = create_request_bulk_order(params)
      response = gateway.create_transaction(request)
      Rails.logger.info "response error #{response.messages.messages[0].text}"
      if success?(response)
        result[:message] = "Congratulations your bulk order payment is successful"
      end
      result
    end

    def create_request_bulk_order(params)
      request = AuthorizeNet::API::CreateTransactionRequest.new
      request.transactionRequest = AuthorizeNet::API::TransactionRequestType.new()
      #TODO: review how to handle absence of appraisal or owner objects in bulk order
      request.transactionRequest.order = AuthorizeNet::API::OrderType.new(Random.new.rand(100000),SecureRandom.hex(4))
      request.transactionRequest.customer = AuthorizeNet::API::CustomerDataType.new(AuthorizeNet::API::CustomerTypeEnum::Individual,Random.new.rand(100000),params[:user_email])

      request.transactionRequest.billTo = billing_address(params[:appraisal][:payment_attributes])
      request.transactionRequest.amount = params[:total_amount].slice!(1, params[:total_amount].length)
      request.transactionRequest.payment = AuthorizeNet::API::PaymentType.new
      request.transactionRequest.payment.creditCard = credit_card(params[:appraisal][:payment_attributes])
      request.transactionRequest.transactionType = AuthorizeNet::API::TransactionTypeEnum::AuthCaptureTransaction
      request
    end

    def charge(appraisal, params)
      result = Hash[:status => false, :message => ""]
      gateway = get_gateway
      request = create_request(appraisal, params)
      response = gateway.create_transaction(request)

      if success?(response)
        Payment.add_payment(response.transactionResponse.authCode, params[:number][-4,4], amount(appraisal, params), appraisal.created_by, appraisal.id)
        coupon = Coupon.find_by_code(params[:coupon])
        if coupon
          coupon.apply!(appraisal)
        end
        appraisal.pay_and_notify!
        result[:status] = true
        result[:message] = "Congratulations your item has been submitted for valuation! You'll be redirected to our home page in a couple of seconds"
      else
        result[:message] = error_message(response)
      end
      result
    end

    def get_gateway
      gateway_type = Rails.env == 'production' ? :production : :sandbox
      AuthorizeNet::API::Transaction.new(PAYMENT_VARS[Rails.env]['authorizenet']['login'], PAYMENT_VARS[Rails.env]['authorizenet']['password'], gateway: gateway_type)
    end

    def create_request(appraisal, params)
      owner = appraisal.owned_by

      request = AuthorizeNet::API::CreateTransactionRequest.new
      request.transactionRequest = AuthorizeNet::API::TransactionRequestType.new()
      request.transactionRequest.order = AuthorizeNet::API::OrderType.new(appraisal.id,appraisal.name)
      request.transactionRequest.customer = AuthorizeNet::API::CustomerDataType.new(AuthorizeNet::API::CustomerTypeEnum::Individual,owner.id,owner.email)

      request.transactionRequest.billTo = billing_address(params)
      request.transactionRequest.amount = amount(appraisal, params)
      request.transactionRequest.payment = AuthorizeNet::API::PaymentType.new
      request.transactionRequest.payment.creditCard = credit_card(params)
      request.transactionRequest.transactionType = AuthorizeNet::API::TransactionTypeEnum::AuthCaptureTransaction
      request
    end

    def amount(appraisal, params)
      user = appraisal.owned_by
      unless user.is_partner && !PartnerPricing.find_by_user_id(user).blank?
        billable_amount = PAYMENT_PLAN[appraisal.selected_plan-1 ]
      else
        billable_amount = get_pricing_of_partner(user, appraisal.selected_plan)
      end

      if !params[:coupon].blank?
        billable_amount= Coupon.details_for(params[:coupon]).calculate_discounted_amount(billable_amount)
      end
      billable_amount
    end

    def credit_card(params)
      AuthorizeNet::API::CreditCardType.new(params[:number], "#{params[:expmon]}#{params[:expyear]}", params[:cvv])
    end

    def billing_address(params)
      AuthorizeNet::API::CustomerAddressType.new(params[:name], "", "", params[:address], params[:city], params[:state], params[:zip], "USA")
    end

    def success?(response)
      response.messages.resultCode == AuthorizeNet::API::MessageTypeEnum::Ok
    end

    def error_message(response)
      "Declined (#{response.messages.messages[0].text})"
    end

    def validate(params)
      appraisal_params = params[:appraisal_params]
      appraisal = params[:appraisal]

      result = Hash[:status => false, :message => ""]
      if appraisal_params[:coupon] && !appraisal_params[:coupon].blank? && !Coupon.is_coupon_valid?(appraisal_params[:coupon])
        result[:message] = "Cannot process: Invalid coupon"
        return result
      end

      coupon = Coupon.find_by_code([:coupon])

      if coupon && !coupon.valid_for_appraisal?(appraisal.selected_plan)
        result[:message] = "Cannot process: Invalid coupon"
        return result
      end

      if appraisal.payed?
        result[:message] = "Cannot process: previous payment exists"
        return result
      end
      result[:status] = true
      result
    end
  end

  #  TODO Return the price of partner customer
  def get_pricing_of_partner(user, selected_plan)
    pricing = PartnerPricing.find_by_user_id(user)
    price = 0

    if selected_plan > 4
      selected_plan -= 4
      price += 20
    end

    plan = PAYMENT_PLAN_FOR_PARTNER[selected_plan]
    case plan
    when "short_restricted"
      price += pricing.short_restricted
    when "full_restricted"
      price += pricing.full_restricted
    when "full_use"
      price += pricing.full_use
    end

    return price
  end
end
