class StrategicPartnersController < ApplicationController
  def index
    p "+==================+"
    @users = User.where(is_partner: true, type: "Customer")
  end
end