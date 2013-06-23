class UserState < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :subscription
end
