class Api::PostsController < Api::ApplicationController
  before_action :authenticate_api_user!

  def index
    posts = Post.all
    render json: posts
  end

  def show
    post = Post.find(params[:id])
    render json: post
  end

  def create
    user = current_api_user
    post = user.posts.build(post_params)
    if post.save
      render json: post
    else
      render json: :unprocessable_entity, status: :unprocessable_entity
    end
  end

  def update
    user = current_api_user
    post_id = params[:id]
    if response = user.user_owns_post?(post_id)
      Post.update(post_id,post_params)
      render json: Post.find(post_id)
    else
      render json: 'You can edit only your own posts.', status: 401 if !response.nil?
      render json: 'Post does not exist.', status: 404 if response.nil?
    end
  end

  def destroy
    user = current_api_user
    post_id = params[:id]
    if response = user.user_owns_post?(post_id)
      Post.destroy(post_id)
      render json: 'Post successfully deleted'
    else
      render json: 'You can delete only your own posts.', status: 401 if !response.nil?
      render json: 'Post does not exist.', status: 404 if response.nil?
    end
  end
  private

  def post_params
    params.require(:post).permit(:title,:body)
  end
end
