ActiveAdmin.register PartnerDetail do
  permit_params :company_name, :company_address, :primary_contact, :company_phone, :company_email, :payment_terms, :vendor_id
  menu :if => proc{ can?(:manage, PartnerDetail) }
  menu :label => "Srategic Partner Details", :parent => "Strategic Partner Management"
  actions :all, :except => [:destroy]
end
