class Subscription < ActiveRecord::Base
  belongs_to :feed, inverse_of: :subscriptions, counter_cache: true
  belongs_to :user
  has_many :entries, through: :feed
  has_many :user_states, through: :entries

  validates_presence_of :feed
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :last_modified

  before_validation :ensure_dependent_fields_are_set

  default_scope { order('subscriptions.last_modified DESC') }

  scope :changed_for, -> (user) {
    joins(:entries)
    .references(:user_states)
    .where.not(
      # slow with otherwise unconstrained subscriptions
      entries: {id: UserState.select(:entry_id).where(seen: true, user: user)})
    .group('subscriptions.id')
  }

  scope :with_stars, -> {
    joins(entries: :user_states)
    .where('subscriptions.user_id = user_states.user_id')
    .where(user_states: {starred: true})
    .group('subscriptions.id')
  }

  def newcount
    entries.unseen_by(user).count
  end

  def changed?
  	newcount > 0
  end

  def url
    feed.url || feed.feed_url
  end

  def update_dependent_fields
    set_last_modified_from_feed
    save!
  end

  def ensure_dependent_fields_are_set
    return unless feed
    set_last_modified_from_feed if self.last_modified.nil?
    set_title_from_feed if self.title.nil?
  end


private

  def set_last_modified_from_feed
    newest_entry = self.feed.entries.first || Entry.new
    self.last_modified = newest_entry.published || self.feed.last_modified || self.feed.updated_at
  end

  def set_title_from_feed
    self.title = self.feed.title || self.feed.url || self.feed.feed_url
  end

end
