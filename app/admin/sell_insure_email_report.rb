ActiveAdmin.register SellInsureEmailReport do
  menu :if => proc{ can?(:manage, SellInsureEmailReport  ) }
  menu :label => "Sell Insure Email History", :parent => "Strategic Partner Management"

  index do
    column :id
    column :appraisal_id
    column :appraisal_name
    column :email_sent_at
    column :customer_name
    column :appraisal_link do |t|
      link_to('Appraisal Link', t.appraisal_link)
    end
  end

  show :title => :appraisal_name do
    attributes_table do
      row :id
      row :appraisal_id
      row :appraisal_name
      row :email_sent_at
      row :customer_name
      row :appraisal_link do
        link_to('Appraisal Link', sell_insure_email_report.appraisal_link)
      end
    end
  end
end