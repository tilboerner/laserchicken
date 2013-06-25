class Entry < ActiveRecord::Base
  include ActionView::Helpers
  belongs_to :feed
  has_many :user_states
  has_many :subscriptions, through: :feed

  default_scope order('published DESC')

  scope :seen_by, -> (user) { joins(:user_states).where(user_states: {user_id: user, seen: true}) }
  scope :unseen_by, -> (user) {
    joins("LEFT OUTER JOIN user_states ON user_states.entry_id = entries.id")\
    .where("user_states.seen IS NOT ? OR user_states.user_id IS NOT ?", true, user.id)
  }

  scope :starred, -> { joins(:user_states).where(user_states: {starred: true}) }
  scope :starred_by, -> (user) { joins(:user_states).where(user_states: {user_id: user, starred: true}) }

  scope :subscribed_by, -> (user) { joins(:subscriptions).where(subscriptions: {user: user}) }

  def unseen?(user)
    self.user_states.where(user: user).seen
  end

  def userstate(user)
    self.user_states.find_or_create_by(user: user)
  end

  def snippet
    truncate(strip_tags((self.summary or self.content)), length: 200, separator: ' ')
  end

  def text
    (self.content or self.summary)
  end

end
