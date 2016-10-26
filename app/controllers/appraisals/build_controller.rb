class Appraisals::BuildController < ApplicationController
  include Wicked::Wizard

  steps :general, :characteristics, :plan, :payment, :thank

  def show
    @appraisal = Appraisal.find(params[:appraisal_id])
    @photos = @appraisal.photos
    Rails.logger.info "in build controller show params #{params}"
    @promo_code = params[:promo_code] if params.has_key?('promo_code')
    if current_user
      @appraisal.payment = Payment.new(user_id: current_user.id, appraisal_id: @appraisal.id) if @appraisal.payment.nil?
    else
      # This is for cases where user is not logged in. temp_user has to be replaced in payment page with new user created.
      temp_user = User.where(:role => ["admin", "superadmin"]).first
      @appraisal.payment = Payment.new(user_id: temp_user.id, appraisal_id: @appraisal.id) if @appraisal.payment.nil?
    end
    render_wizard
  end

  def create
    Rails.logger.info "create params #{params}"
    if current_user
      @appraisal = Appraisal.create(created_by: current_user.id, status: EActivityValueCreated)
    else
      @appraisal = Appraisal.create(status: EActivityValueCreated)
      @appraisal.title = params[:title] if params.has_key?("title")
      @appraisal.save
    end
    redirect_to wizard_path(steps.first, :appraisal_id => @appraisal.id)
  end

  def update
    @appraisal = Appraisal.find(params[:appraisal_id])
    Rails.logger.info "params[:id] is #{params[:id]}"
    unless (["plan", "payment"].include?(params[:id]))
      params[:appraisal][:appraisal_info] = @appraisal.merge_appraisal_info(params)
    end
    # added classification_attributes as it is giving error
    #params[:appraisal].except!(:payment_attributes, :classification_attributes, :appraisal_info_attributes)
    params[:appraisal][:step] = step
    params[:appraisal][:step] = 'active' if step == steps.last
    params[:appraisal][:selected_plan] = (params[:appraisal][:selected_plan].to_i + 4) if params[:isPair]
    classifications = params[:appraisal][:classification_attributes]
    unless classifications.nil?
      classification = Classification.where(appraisal_id: @appraisal.id)
      if classification.count > 0
        Classification.update(classification.first.id, category_id: classifications["category"].to_i)
      else
        Classification.create(appraisal_id: @appraisal.id, category_id: classifications["category"].to_i)
      end
    end
    params[:appraisal].delete(:classification_attributes)
    params[:appraisal].delete(:current_user)
    params[:appraisal].delete(:payment_attributes)
    if params[:id] == "payment" && !params[:promo_code].blank?
      bulk_order = BulkOrder.where(:promo_code => params[:promo_code]).first
      if !bulk_order.nil? && bulk_order.selected_plan == @appraisal.selected_plan && bulk_order.credits_count > 0
        @appraisal.pay!
        bulk_order.credits_remaining = bulk_order.credits_remaining - 1
        bulk_order.save
      end
    end

    @appraisal.update_attributes(params[:appraisal])
    # giving error if appraiser id is not valid
    @appraisal.assigned_to = Appraiser.find(@appraisal.appraiser_referral.to_i) unless @appraisal.appraiser_referral.blank?
    @appraisal.save
    @appraisal.reload
    @appraisal.payment.reload if @appraisal.payment
    render_wizard @appraisal
  end


end
