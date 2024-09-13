require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Posts", type: :request do
  describe "user is not authenticated" do
    before do
      @user = User.create!(email:'test@gmail.com',password:123456789, uid:'test@gmail.com')
      @post = @user.posts.create!(title: 'post title', body: 'post body')
    end
    context 'get posts_path' do
    it 'returns status 200' do
      get posts_path
      expect(response).to have_http_status(200)
     end
    end
    context 'get new_post_path' do
      it 'returns 302' do
        get new_post_path
        expect(response).to have_http_status(302)
      end
    end
    context 'get edit_post_path' do
      it 'returns 302' do
        get edit_post_path(@post)
        expect(response).to have_http_status(302)
      end
    end
    context 'post delete_post_path' do
      it 'returns 302' do
        delete post_path(@post)
        expect(response).to have_http_status(302)
      end
    end
  end
  describe 'user is authenticated' do
    before do
      @valid_params = {params: {post: {title: 'title', body: 'body'}}}
      @invalid_params = {params: {post: {title: '' , body: 'body'}}}
      @user = User.create!(email:'test@gmail.com',password:123456789, uid:'test@gmail.com')
      @post = @user.posts.create!(title:'title', body:'body')

      sign_in @user
    end
    context 'when user gets to new_post_path and create post' do
      it 'returns 200 for get new_post_path' do
        get new_post_path
        expect(response).to have_http_status(200)
      end
      it 'with valid data creates a post and redirects to post path' do
        post posts_path(@valid_params)
        expect(response).to redirect_to posts_path
      end
      it 'with invalid data a post is not created and returns 422' do
        post posts_path(@invalid_params)
        expect(response).to have_http_status(422)
      end
    end
    context 'when user gets to edit_post_path and edit post' do
      it 'returns 200 for get edit_post_path' do
        get edit_post_path(@post)
        expect(response).to have_http_status(200)
      end
      it 'with valid data edit a post and redirects to post path' do
        patch post_path(@post), params: {post: {title: 'title', body: 'body'}}
        expect(response).to redirect_to posts_path
      end
    end
    context 'when user deletes post' do
      it 'deletes a post and redirects to posts_path' do
      delete post_path(@post)
      expect(response).to redirect_to posts_path
      end
    end
  end
end
