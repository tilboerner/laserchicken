class User < ActiveRecord::Base
  has_secure_password

  has_many :subscriptions, dependent: :destroy
  has_many :user_states, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :password, length: { minimum: 10 }

  before_save :make_admin_if_must
  before_destroy :make_sure_admin_deleted_last

  before_validation { self.password_confirmation = self.password }


  scope :admin, -> { where(is_admin: true) }


  def must_be_admin?
    if is_admin?
      User.admin.count < 2
    else
      not User.admin.exists?
    end
  end

private

  def make_sure_admin_deleted_last
    if must_be_admin? && User.count > 1
      errors[:is_admin] = ": Cannot delete last admin while other users exist."
      return false
    end
  end

  def make_admin_if_must
    self.is_admin = true if must_be_admin?
  end

end
