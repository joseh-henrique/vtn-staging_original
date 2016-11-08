require 'set'
module PeriodicJobs

  def self.email_sales_receipts
    #appraisals = Appraisal.where(status: EActivityValuePayed).where('updated_at > ?', 24.hours.ago)
    appraisals = Appraisal.where(status: EActivityValuePayed).limit(10)
    customer_ids = Set.new
    appraisals.each do |appraisal|
      customer_ids.add appraisal.created_by
    end
    template_file = "/appraisals/reports/sales_receipt.pdf.erb"
    customer_ids.each do |customer_id|
      @customer = User.find_by_id(customer_id)

    end
    appraisals.each do |appraisal|
      Dir.mkdir(PDF_DIR) if !Dir.exists?(PDF_DIR)
      file = PDF_DIR + rand(10000).to_s + ".pdf"
      open(file, 'wb') do |file|
        file << open(Rails.application.config.server_url + "/appraisals/sales_receipt/#{@appraisal.id}.pdf?full=no").read
      end
      result = Cloudinary::Uploader.upload(file, {:resource_type => 'raw'})
      pdf_link = result["secure_url"]
      Rails.logger.info "result is #{result} and @pdf_link is #{pdf_link}"
      UserMailer.sell_insure_notify(partner_detail, subject, sell_insure, static_content, @appraisal, pdf_link).deliver_now
    end
  end
end