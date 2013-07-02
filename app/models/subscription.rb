class Subscription < ActiveRecord::Base
  belongs_to :feed, counter_cache: true
  belongs_to :user
  has_many :entries, through: :feed
  has_many :user_states, through: :entries

  default_scope { includes(:feed).order('feeds.last_modified DESC') }

  scope :changed_for, -> (user) {
    joins(:entries).
    joins('LEFT OUTER JOIN user_states ON user_states.entry_id = entries.id').
    where('user_states.user_id IS NOT ? OR user_states.seen IS NOT ?', user.id, true).
    group('subscriptions.id') }


  validates_presence_of :feed
  validates_presence_of :user

  def newcount
    entries.unseen_by(user).count
  end

  def changed?
  	newcount > 0
  end

  def title
    feed.title
  end

  def url
    feed.url
  end

end
