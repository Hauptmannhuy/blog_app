class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit,:destroy,:update]
  def index
    @current_user = current_user
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
   if post.update(post_params)
     redirect_to posts_path
   else
    render :edit, status: :unprocessable_entity
   end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def post_params
    params.require(:post).permit(:title,:body)
  end
end
