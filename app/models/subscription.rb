class Subscription < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  has_many :entries, through: :feed
  has_many :user_states, through: :entries

  default_scope joins(:feed).order('last_modified DESC')

  scope :changed_for, -> (user) {
    joins(:entries).
    joins('LEFT OUTER JOIN user_states ON user_states.entry_id = entries.id').
    where('user_states.seen IS NOT ?', true).where(user_states: {user: user}).
    group('subscriptions.id') }

  def newcount
  	feed.entries.unseen_by(user).count
  end

  def changed?
  	newcount > 0
  end

end
