class Subscription < ActiveRecord::Base
  belongs_to :feed, counter_cache: true
  belongs_to :user
  has_many :entries, through: :feed
  has_many :user_states, through: :entries

  default_scope { includes(:feed).order('feeds.last_modified DESC') }

  scope :changed_for, -> (user) {
    joins(:entries)
    .references(:user_states)
    .where.not(
      # slow with otherwise unconstrained subscriptions
      entries: {id: UserState.select(:entry_id).where(seen: true, user: user)}
    )
    .group('subscriptions.id')
  }

  scope :with_stars, -> {
    joins(entries: :user_states)
    .where('subscriptions.user_id = user_states.user_id')
    .where(user_states: {starred: true})
    .group('subscriptions.id')
  }


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
