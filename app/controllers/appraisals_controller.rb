class AppraisalsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, :except => [:show_shared, :bulk_order_promo]
  before_filter :is_appraiser_confirmed, :except => [:wizard_photo_upload, :wizard_categories, :show_shared, :bulk_order_promo]
  PDF_DIR        = "#{Rails.root}/tmp/pdf_dir_#{Process.pid}/"
  # GET /appraisals
  def index
    # TODO Check if performance can be improved
    # Order appraisals by specific status
    @user = current_user
    @appraisals = []
    [EActivityValueCreated, EActivityValuePayed, EActivityValueClaimed, EActivityValueFinalized].each do |s|
      @appraisals << Appraisal.where(:created_by => @user.id, :status =>s ).order("updated_at desc")
    end
    @appraisals = @appraisals.flatten
    @appraisals = Kaminari.paginate_array(@appraisals).per_page_kaminari(params[:page]).per(10)

    if @appraisals.blank?
      @appraisal = Appraisal.new
      1.times { @appraisal.photos.build }
    end

    get_flash_coupon

    respond_to do |format|
      format.html
    end
  end

  # GET /appraisals/1
  def show
    @appraisal = Appraisal.find(params[:id])
    @photos = @appraisal.photos
    if (@appraisal.status != EActivityValuePayed) && (@appraisal.assigned_to != current_user) && (@appraisal.created_by != current_user.id) && (!current_user.admin?)
      flash[:error]  = "We are sorry, but the appraisal request you are attempting to view has already been claimed."
      return redirect_to root_path
    end
    # TODO Guarantee that only appraisals from production environment are sent to the affiliate program
    @payment_completed = flash[:payment_completed] == @appraisal.id
    @user = User.find_by_id(current_user)
    @appraisal_comments = @appraisal.root_comments.order('created_at ASC')
    if (!@appraisal.assigned_to.nil?)
      @appraiser = User.find_by_id(@appraisal.assigned_to)
    end
    flash[:title] = "Appraisal" unless !flash[:title].nil?

    respond_to do |format|
      format.html #{ render :layout => 'shareable' }# show.html.erb
    end
  end

  def show_shared
    @appraisal = Appraisal.find(params[:id])
    @supplemental ||= params[:supplemental]
    @appraiser = @appraisal.assigned_to
    @pdf_full ||= params[:full]
    @appraisal_comments = @appraisal.root_comments.order('created_at ASC')
    template_file = (@pdf_full.eql?"yes") ? "/appraisals/reports/full.pdf.erb" : "/appraisals/reports/lacey.pdf.erb"
    Rails.logger.info "selected plan is #{@appraisal.selected_plan} PDF_FULL IS #{@pdf_full} template_file is #{template_file}"
    respond_to do |format|
      format.pdf { render :pdf => 'report', :page_size => "Legal", :show_as_html => params[:debug].present?, :template => template_file }
    end
  end

  # GET /appraisals/new
  def new
    @appraisal = Appraisal.new
    1.times { @appraisal.photos.build }

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /appraisals/1/edit
  def edit
    @appraisal = Appraisal.find(params[:id])
    if @appraisal.created_by != current_user.id
      flash[:error]  = "We are sorry, but the appraisal request you are attempting to view has already been claimed."
      redirect_to root_path
    end
  end

  def reply
    @appraisal = Appraisal.find(params[:id])
    if @appraisal.assigned_to != current_user
      flash[:error]  = "We are sorry, but the appraisal request you are attempting to view has already been claimed."
      redirect_to root_path
    end
    @appraisal_comments = @appraisal.retrieve_comments
  end

  # POST /appraisals
  def create
    params[:appraisal][:appraisal_info] = AppraisalInfo.new(params[:appraisal][:appraisal_info])
    @appraisal = Appraisal.new(params[:appraisal])
    @appraisal.created_by = current_user.id
    @appraisal.status = EActivityValueCreated

    if @appraisal.save
      session[:new_appraisal] = @appraisal.id
      # redirect_to payments_path(:appraisal_id => @appraisal.id) 
      redirect_to wizard_photo_upload_path(:appraisal_id => @appraisal.id)     
    else
      respond_to do |format|
        flash[:error] = 'Appraisal cannot be created!'
        format.html { render :action => "new" }
      end
    end

  end

  # PUT /appraisals/1
  def update
    @appraisal = Appraisal.find(params[:id])

    if params[:suggest_rejection] && params[:appraisal][:status] == "14"
      pending_rejection = @appraisal.suggest_for_rejection(rejection_reason: params[:txtRejectionReason])
    end
    previous_status = @appraisal.status
    params[:appraisal][:appraisal_info] = Hash.new if params[:appraisal][:appraisal_info].nil?
    current_appraisal_info = @appraisal.appraisal_info.instance_values
    current_appraisal_info.merge!(AppraisalInfo.new(params[:appraisal][:appraisal_info]).instance_values)
    params[:appraisal][:appraisal_info] = AppraisalInfo.new(current_appraisal_info)

    respond_to do |format|
      if pending_rejection
        format.html { redirect_to(@appraisal, :notice => 'Appraisal was sent to administrator for review.') }
      elsif @appraisal.update_attributes(params[:appraisal])
        if @appraisal.status == EActivityValueFinalized && previous_status != EActivityValueFinalized
          # Send Notification via Email to Creator about Finalized Appraisal
          payout = Payout.find_or_create_by(:appraisal_id => @appraisal.id, :appraiser_id => @appraisal.assigned_to.id)
          payout.amount = @appraisal.paid_amount
          payout.status = EAPayoutPending 
          payout.save
          @appraisal.owned_by.notify_creator_of_appraisal_update( @appraisal )
        elsif params[:notify_user]
          @appraisal.owned_by.notify_creator_of_appraisal_update( @appraisal )
        end
        format.html { redirect_to(@appraisal, :notice => 'Appraisal was successfully updated.') }
      else
        @appraisal_comments = @appraisal.retrieve_comments
        @appraisal.status = Appraisal.find(params[:id]).status # This is so the previous status is kept when returning to reply view after invalid parameters #53889653
        format.html { render :action => current_user.is_appraiser? ? "reply" : "edit" }
      end
    end
  end


  # DELETE /appraisals/1
  def destroy
    @appraisal = Appraisal.find(params[:id])
    @appraisal.destroy
    respond_to do |format|
      format.html { redirect_to(root_path, :notice => 'Appraisal was deleted successfully.') }
    end
  end

  def claim
    #if Rails.env != 'sandbox' && !Appraisal.processing.where(assigned_to: current_user).empty?
      #redirect_to(@appraisal, :alert => "You can only have one processing appraisal at a time.")
    #else
      @appraisal = Appraisal.find(params[:id])
      if @appraisal.claim!(appraiser: current_user)
        redirect_to reply_appraisal_path(@appraisal)
      else
        redirect_to(@appraisal, :alert => "Please try claiming this item again in a few minutes.")
      end
    #end
  end

  def completed
    @appraisal = Appraisal.find(params[:id])
    @sell_insure = SellInsure.new
    @button_clicked = params[:button_clicked]
    Rails.logger.info "appraisal completed params #{params}"
  end

  def process_completed
    Rails.logger.info "params is #{params}"
    @appraisal = Appraisal.find(params[:id])
    sell_insure = SellInsure.new(sell_insure_params(params))
    if params[:email_phone] == "0"
      sell_insure.email_only = true
    elsif params[:email_phone] == "1"
      sell_insure.phone_only = true
    elsif params[:email_phone] == "2"
      sell_insure.phone_or_email = true
    end
    sell_insure.appraisal_id = params[:id]
    sell_insure.save

    #AppraisalsController.delay.send_mail_and_save(params, sell_insure)
    AppraisalsController.delay.send_mail_and_save(params, sell_insure, current_user)
  end

  def self.send_mail_and_save(params, sell_insure, current_user)
    @appraisal = Appraisal.find(params[:id])
    page = Comfy::Cms::Page.find_by_full_path("/#{params[:button_clicked]}")
    static_content = page.content_cache
    subject = "Enquiry"

    Dir.mkdir(PDF_DIR) if !Dir.exists?(PDF_DIR)
    file = PDF_DIR + rand(10000).to_s + ".pdf"
    open(file, 'wb') do |file|
      file << open(Rails.application.config.server_url + "/appraisals/show_shared/#{@appraisal.id}.pdf?full=no").read
    end
    result = Cloudinary::Uploader.upload(file, {:resource_type => 'raw'})

    pdf_link = result["secure_url"]
    Rails.logger.info "result is #{result} and @pdf_link is #{pdf_link}"
    PartnerDetail.all.each do |partner_detail|
      UserMailer.sell_insure_notify(partner_detail, subject, sell_insure, static_content, @appraisal, pdf_link).deliver_now
    end
    t = Time.now
    emailed_on = t.strftime("Emailed on %m/%d/%Y at %I:%M%p")
    SellInsureEmailReport.create(appraisal_id: @appraisal.id, appraisal_name: @appraisal.name, email_sent_at: emailed_on, customer_id: current_user.id, customer_name: sell_insure.customer_name, appraisal_link: pdf_link)
  end

  def sell_insure_params user_params
    user_params.require(:sell_insure).permit(:customer_name, :email, :phone, :message)
  end

  def recipient_list
    recipients = ""
    PartnerDetail.all.each do |pd|
      recipients.concat(pd.company_email).concat(",")
    end
    recipients.chop if recipients.end_with(",")
  end

  def bulk_order_promo
    Rails.logger.info "in bulk_order_promo #{params}"
    #appraisal = Appraisal.create
    if current_user
      session[:promo_code] = params[:promo_code]
      redirect_to root_path
    else
      appraisal = Appraisal.create
      redirect_to appraisal_build_index_path(appraisal_id: appraisal.id)
    end
  end

  def wizard_photo_upload
    @appraisal = Appraisal.find(params[:appraisal_id])
  end

  def wizard_categories
    @appraisal = Appraisal.find(params[:appraisal_id])
  end

  def share
    @appraisal = Appraisal.find(params[:appraisal_id])
    if !@appraisal.nil? && current_user.id == @appraisal.created_by
      @appraisal.shared = true
      @appraisal.save
    end
    respond_to do |format|
      format.json  { render :json =>  @appraisal }
    end
  end

  def comment
    @appraisal = Appraisal.find(params[:comment_appraisal_id])
    @comment = Comment.build_from(@appraisal, current_user.id, params[:comment][:body])
    respond_to do |format|
      if @comment.save
        format.html {flash[:notice] = 'Comment added successfully'; redirect_to @appraisal}
        format.json {render :json => @comment}
      else
        format.html {flash[:error] = 'Comment could not be created'; redirect_to @appraisal}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    if current_user.admin?
      @appraisal = Appraisal.find(params[:id])

      type = params[:btn_submit]
      case type
        when "Return to Appraiser"
          @appraisal.return_to_claimed_status
          flash[:error]  = "The appraisal was returned for claimed status"
          redirect_to admin_root_path
        when "Return to queue"
          if @appraisal.status != 0
            @appraisal.return_to_queue
            flash[:error] = "The appraisal was returned to queue"
            redirect_to admin_root_path
          else
            flash[:error] = "Can not return incompleted appraisal to queue"
            redirect_to admin_appraisal_path(@appraisal)
          end
        when "Assign to Appraiser ID"
          appraiser_id = params[:appraiser_id].to_i
          unless appraiser_id <= 0 || appraiser_id > 999
            
            if Appraiser.exists?(appraiser_id) && Appraiser.find(appraiser_id).type == "Appraiser"
              appraiser = Appraiser.find(appraiser_id)
              if appraiser.status == 2
                @appraisal.assign_to_appraiser_id(appraiser)
                flash[:error] = "The appraisal was assigned to Appraiser with ID: #{params[:appraiser_id]}"
                redirect_to admin_root_path
              else
                flash[:error] = "Please be noticed that the appraisal only be assigned to the Confirmed Appraiser"
                redirect_to admin_appraisal_path(@appraisal)
              end
            else
              flash[:error] = "Appraiser is not found"
              redirect_to admin_appraisal_path(@appraisal)
            end
          else
            flash[:error] = "Appraiser with ID must be between 1 and 999"
            redirect_to admin_appraisal_path(@appraisal)
          end
        else
          @appraisal.reject(params[:comments])
          flash[:error]  = "The appraisal was rejected"
          redirect_to admin_root_path
      end    
    end
    
  end


  protected
  def is_appraiser_confirmed
    redirect_to :appraiser_steps if current_user.is_appraiser? && current_user.status != EAUserStatusConfirmed
  end

  def get_flash_coupon
    if session[:coupon]
      coupon = Coupon.details_for(session[:coupon]).legend
      if Coupon.is_coupon_valid?(session[:coupon])
        flash[:notice] = Coupon.details_for(session[:coupon]).legend
      end
    end
  end
end
