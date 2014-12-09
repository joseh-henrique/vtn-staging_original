class Sharecount < ActiveRecord::Base
  belongs_to :appraisal
  belongs_to :user
  attr_accessible :network, :user_id, :appraisal_id

  validates_presence_of :user_id
  validates_presence_of :appraisal_id
  validates_presence_of :network
end
