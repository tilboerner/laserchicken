class Feed < ActiveRecord::Base
	has_many :entries, dependent: :destroy
end
