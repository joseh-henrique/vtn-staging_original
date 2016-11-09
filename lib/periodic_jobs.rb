require 'set'
require 'open-uri'
module PeriodicJobs
  PDF_DIR        = "#{Rails.root}/tmp/pdf_dir_#{Process.pid}/"

  def self.email_sales_receipts
    #appraisals = Appraisal.where(status: EActivityValuePayed).where('updated_at > ?', 24.hours.ago)
    appraisals = Appraisal.where(status: EActivityValuePayed).where('updated_at > ?', 1.hour.ago)
    if appraisals.count > 0
      #appraisals = Appraisal.where(status: EActivityValuePayed).limit(5)
      customer_ids = Set.new
      appraisals.each do |appraisal|
        customer_ids.add appraisal.created_by
      end
      customer_ids.each do |customer_id|
        customer = User.find_by_id(customer_id)
        #UsersController.delay.invoke_sales_receipt(@customer)
        receipt_id = 1
        receipt_id = SalesReceipt.maximum("receipt_id") + 1 if SalesReceipt.all.count > 0
        sales_receipt = SalesReceipt.create(receipt_id: receipt_id, customer_id: customer_id, email_sent_at: Time.now)

        Dir.mkdir(PDF_DIR) if !Dir.exists?(PDF_DIR)
        file = PDF_DIR + rand(10000).to_s + ".pdf"
        open(file, 'wb') do |file|
          file << open(Rails.application.config.server_url + "/users/sales_receipt/#{customer_id}.pdf?receipt_id=#{receipt_id}", "Content-Type" => "application/pdf").read
        end
        result = Cloudinary::Uploader.upload(file, {:public_id => "sales_receipt_#{sales_receipt.id}", :resource_type => :raw})
        pdf_link = result["secure_url"]
        sales_receipt.pdf_url = pdf_link
        sales_receipt.save
        Rails.logger.info "result is #{result} and @pdf_link is #{pdf_link}"
        subject = "Sales Receipt"
        UserMailer.email_sales_receipt(customer.email, subject, pdf_link, customer.name).deliver_now
      end
    else
      Rails.logger.info "No appraisals created"
    end
  end
end