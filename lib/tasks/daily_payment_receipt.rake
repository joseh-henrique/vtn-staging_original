desc "Send daily payment receipt"
task :daily_payment_receipt => :environment do
  puts "Sending daily payment receipt......"
  customer_ids = Payment.for_today.pluck(:user_id).uniq
  Customer.where(id: customer_ids).each do |customer|
    appraisals = customer.appraisals_created_today
    UserMailer.delay.daily_payment_receipt(customer, appraisals)
  end
  puts "Done."
end

