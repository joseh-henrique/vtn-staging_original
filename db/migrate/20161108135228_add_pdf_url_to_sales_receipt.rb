class AddPdfUrlToSalesReceipt < ActiveRecord::Migration
  def change
    add_column :sales_receipts, :pdf_url, :string
  end
end
