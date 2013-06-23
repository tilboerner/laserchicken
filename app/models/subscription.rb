class Subscription < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  has_many :user_states

  scope :changed, -> { \
   joins('LEFT OUTER JOIN user_states ON user_states.subscription_id = subscriptions.id') \
   .where("user_states.seen IS NOT ?", true) \
  }

  def newcount
  	feed.entries.unseen_by(user).count
  end

  def changed?
  	newcount > 0
  end

end
