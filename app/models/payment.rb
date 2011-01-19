class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :pricing_plan
  belongs_to :subscription
end
