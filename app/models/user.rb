class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :posts
  has_many :comments, through: :posts


  def user_owns_post?(post_id)
   post = Post.where(id:post_id)[0]
   return true if self.id == post.user_id
   post.nil? ? "Post doesn't exist" : false
  end
end
