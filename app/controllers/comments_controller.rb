class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to posts_path
    else
      redirect_to posts_path, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id,:post_id)
  end
end
