class Post < ActiveRecord::Base
  belongs_to :user
  has_many :likes, dependent: :destroy
  acts_as_commentable
  validates :user, :body, presence: true
end
