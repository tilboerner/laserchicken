class Entry < ActiveRecord::Base
  include ActionView::Helpers
  belongs_to :feed, counter_cache: true
  has_many :user_states, dependent: :destroy
  has_many :subscriptions, through: :feed

  validates :feed_id, presence: true

  default_scope { order('entries.published DESC, entries.id DESC') }

  scope :seen_by, -> (user) { joins(:user_states).where(user_states: {user_id: user, seen: true}) }
  scope :unseen_by, -> (user) {
    # slow for huge, otherwise unconstrained collections of entries
    where.not(id: UserState.select(:entry_id).where(user: user, seen: true))
  }

  scope :starred, -> { joins(:user_states).where(user_states: {starred: true}) }
  scope :starred_by, -> (user) { joins(:user_states).where(user_states: {user_id: user, starred: true}) }

  scope :subscribed_by, -> (user) { joins(:subscriptions).where(subscriptions: {user: user}) }

  def unseen?(user)
    state = self.user_states.where(user: user).first
    state.nil? || state.seen?
  end

  def subscribed_by?(user)
    feed.subscriptions.where(user: user).exists?
  end

  def userstate(user)
    user_states.find_by(user: user) or UserState.new(user: user, entry: self)
  end

  def snippet
    truncate(strip_tags((self.summary or self.content or '')), length: 200, separator: ' ')
  end

  def text
    (self.content || self.summary || '')
  end

  def timestr
    if self.published
      time_ago_in_words(self.published).sub('about', '~').sub(/ hours?/, 'h')
    else
      ''
    end
  end

end
