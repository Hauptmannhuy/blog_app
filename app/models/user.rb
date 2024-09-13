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
   if post.nil?
    nil
   elsif self.id != post.user_id
    false
   else
    true
   end
  end
end
