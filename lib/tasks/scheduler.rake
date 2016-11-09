desc "This task is used for notify uncomplete appraisal"
task :auto_email_when_uncomplete => :environment do
  puts "Sending email......"
  Appraisal.delay.auto_email_when_uncomplete
  puts "Done."
end

desc "This task is used to send sales receipts for appraisals paid for in the previous day"
task :email_sales_receipt => :environment do
  PeriodicJobs.delay.email_sales_receipts
end
