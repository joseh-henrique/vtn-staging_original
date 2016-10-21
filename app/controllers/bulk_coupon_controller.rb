class BulkCouponController < ApplicationController

  def show

  end

  def new
    @bulk_order = BulkOrder.new
  end

  def create
    Rails.logger.info "in create params is #{params}"
  end

end