
  ActiveAdmin.register_page "VTN Statistics" do
    menu :label => "Average Customers Repeat Use", :parent => "VTN Statistics"
    content do
        render :partial => "admin/reports/average_customers_repeat_use.html", locals: {appraisals: appraisals, customers: customers}
    end

    controller do
      def index
        @appraisals = Appraisal.where(status: 10).count
        @customers = Appraisal.where(status: 10).map(&:owned_by).map(&:id).uniq.count
      end
    end

  end