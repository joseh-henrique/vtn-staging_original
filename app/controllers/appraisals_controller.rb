class AppraisalsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, :except => [:show_shared]
  before_filter :is_appraiser_confirmed, :except => [:wizard_photo_upload, :wizard_categories, :show_shared]

  # GET /appraisals
  def index
    # TODO Check if performance can be improved
    # Order appraisals by specific status
    @user = current_user
    @appraisals = []
    [EActivityValueCreated, EActivityValuePayed, EActivityValueClaimed, EActivityValueFinalized].each do |s|
      @appraisals << Appraisal.where(:created_by => @user.id, :status =>s )
    end
    @appraisals = @appraisals.flatten

    if @appraisals.empty?
      @appraisal = Appraisal.new
      1.times { @appraisal.photos.build }
    end

    respond_to do |format|
      format.html
    end
  end

  # GET /appraisals/1
  def show
    @appraisal = Appraisal.find(params[:id])
    if (@appraisal.status != EActivityValuePayed) && (@appraisal.assigned_to != current_user) && (@appraisal.created_by != current_user.id) && (!current_user.admin?)
      flash[:error]  = "We are sorry, but the appraisal request you are attempting to view has already been claimed."
      return redirect_to root_path
    end
    # TODO Guarantee that only appraisals from production environment are sent to the affiliate program
    @payment_completed = flash[:payment_completed] == @appraisal.id
    @long ||= params[:pdf_long]
    @full ||= params[:pdf_full]
    @user = User.find_by_id(current_user)
    @appraisal_comments = @appraisal.root_comments.order('created_at ASC')
    @supplemental ||= params[:supplemental]
    if (!@appraisal.assigned_to.nil?)
      @appraiser = User.find_by_id(@appraisal.assigned_to)
    end
    flash[:title] = "Appraisal" unless !flash[:title].nil?

    respond_to do |format|
      format.html #{ render :layout => 'shareable' }# show.html.erb
      format.pdf { render :pdf => 'file_name.pdf', :page_size => "Legal", :show_as_html => params[:debug].present?, :template => "/appraisals/finalized.pdf.erb" }
    end
  end

  def show_shared
    @appraisal = Appraisal.find(params[:id])
    @appraiser = @appraisal.assigned_to

    if @appraisal.shared
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_path
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
    if params[:suggest_rejection]
      pending_rejection = @appraisal.suggest_for_rejection(reason: params[:txtRejectionReason])
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
          payout = Payout.find_or_create_by_appraisal_id_and_appraiser_id(:appraisal_id => @appraisal.id, :appraiser_id => @appraisal.assigned_to.id)
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
    if Rails.env != 'sandbox' && !Appraisal.processing.where(assigned_to: current_user).empty?
      redirect_to(@appraisal, :alert => "You can only have one processing appraisal at a time.")
    else
      @appraisal = Appraisal.find(params[:id])
      if @appraisal.claim!(appraiser: current_user)
        redirect_to reply_appraisal_path(@appraisal)
      else
        redirect_to(@appraisal, :alert => "Please try claiming this item again in a few minutes.")
      end
    end
  end

  # TODO Remove this
  def test
    @appraisal = Appraisal.find(params[:id])
    @user = User.find_by_id(current_user)
    if (!@appraisal.assigned_to.nil?)
      @appraiser = User.find_by_id(@appraisal.assigned_to)
    end
    flash[:title] = "Appraisal" unless !flash[:title].nil?

    respond_to do |format|
      format.html #{ render :layout => 'shareable' }# show.html.erb
      format.pdf { render :pdf => 'file_name.pdf', :page_size => "letter", :show_as_html => params[:debug].present?, :template => "/appraisals/finalized.pdf.erb" }
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
      @appraisal.reject(params[:comments])
      flash[:error]  = "The appraisal was rejected"
    end
    redirect_to admin_root_path
  end


  protected
  def is_appraiser_confirmed
    redirect_to :appraiser_steps if current_user.is_appraiser? && current_user.status != EAUserStatusConfirmed
  end
end
