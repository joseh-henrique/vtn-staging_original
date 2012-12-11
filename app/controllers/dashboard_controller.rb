class DashboardController < ApplicationController
	def index
		@user = current_user
		if @user.is_customer?
			redirect_to users_url
		else
			@specializedAppraisals = nil
			
			case @detail = params[:detail]
				when "processing"
					@appraisals = Appraisal.where("assigned_to = ? and status = ?",current_user,EActivityValueClaimed)
				when "unclaimed"
					@appraisals = Appraisal.where('status = ?', EActivityValuePayed)
				when "completed"
					@appraisals = Appraisal.where("assigned_to = ? and status = ?",current_user,EActivityValueFinalized)
				else
					@appraisals = Appraisal.where("assigned_to = ? or status = ?", current_user, EActivityValuePayed)
				end
			if params[:specialized]
				@specializedAppraisals = Appraisal.select("appraisals.id").joins(:classifications => {:category => {:skills => :appraiser}}).where('appraisals.status in (?) and categories.id in (?)', [EActivityValuePayed, EActivityValueFinalized,EActivityValueClaimed ],current_user.skills.pluck(:category_id).uniq).pluck('appraisals.id').uniq
				@appraisals = @appraisals.where("id in (?)",@specializedAppraisals)
			end				

			respond_to do |format|
				format.html # index.html.haml
				format.xml  { render :xml => @appraisals }
			end
		end
	end

	def payouts
		@payouts = Payout.joins(:appraisal).where("appraisals.assigned_to = ?",current_user)

		case params[:status]
		when 'pending'
			@payouts = @payouts.where("payouts.status = ?", EAPayoutPending)
		when 'completed'
			@payouts = @payouts.where("payouts.status = ?", EAPayoutCompleted)
		end
	end
end