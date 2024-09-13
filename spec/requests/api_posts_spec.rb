require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "api_posts_controller when user authenticated", type: :request do
  before do
    post api_user_registration_path, params: {email:"email@mail.com", password: '123456789' }
    post api_user_registration_path, params: {email:"email2@mail.com", password: '123456789' }
    @user = User.find_by(email:'email@mail.com')
    @other_user =User.find_by(email:'email2@mail.com')
    @non_authorized_client = User.new(email:'lol@mail.com', password:'123456789')
  end
  context "User is not authenticated " do
    it "when user is trying to post to api/posts gives status 401" do
      post api_posts_path, :params => {title: '123',body:'1245'}
      expect(response).to have_http_status(401)
    end
    it "when user is trying to get to api/posts gives status 401" do
      get api_posts_path
      expect(response).to have_http_status(401)
    end
    it "when user is trying to put to api/posts gives status 401" do
      post = @user.posts.create!(title: 'title', body: 'body')
      patch api_post_path(post.id), params: {title: '1245'}
      expect(response).to have_http_status(401)
    end
    it "when user is trying to delete to api/posts gives status 401" do
      post = @user.posts.create!(title: 'title', body: 'body')
      delete api_post_path(post.id)
      expect(response).to have_http_status(401)
    end
end
context "User is authenticated" do
  it "when user is trying to get api/posts gives status 200" do
    login(@user)
    headers = get_auth_params_from_login_response_headers(response)
    get api_posts_path, headers: headers
    expect(response).to have_http_status(200)
  end
  it "when user is trying to post to api/posts with valid data gives status 200" do
    login(@user)
    headers = get_auth_params_from_login_response_headers(response)
    post api_posts_path, params: {post:{title: 'title', body: 'body'}}, headers: headers
    expect(response).to have_http_status(200)
  end
  it "when user is trying to post to api/posts with invalid data gives status 422" do
    login(@user)
    headers = get_auth_params_from_login_response_headers(response)
    post api_posts_path, params: {post:{title: '', body: 'body'}}, headers: headers
    expect(response).to have_http_status(422)
  end
  it 'when user is trying to put to api/post/id gives 200' do
    login(@user)
    post = @user.posts.create!(title: 'title', body: 'body')
    headers = get_auth_params_from_login_response_headers(response)
    put api_post_path(post.id), params: {post:{title: 'lol', body: 'kek'}}, headers: headers
    expect(response).to have_http_status(200)
  end
  it 'when user is trying to put to non-owned post gives 401' do
    post = @user.posts.create!(title: 'title', body: 'body')
    login(@other_user)
    headers = get_auth_params_from_login_response_headers(response)
    put api_post_path(post.id), headers: headers
    expect(response).to have_http_status(401)
    expect(response.body).to eql('You can edit only your own posts.')
  end
  it 'when user is trying to delete own post gives 200' do
    login(@user)
    post = @user.posts.create!(title: 'title', body: 'body')
    headers = get_auth_params_from_login_response_headers(response)
    delete api_post_path(post.id), headers: headers
    expect(response).to have_http_status(200)
  end
  it 'when user is trying to delete non-owned post gives 401' do
    post = @user.posts.create!(title: 'title', body: 'body')
    login(@other_user)
    headers = get_auth_params_from_login_response_headers(response)
    delete api_post_path(post.id), headers: headers
    expect(response).to have_http_status(401)
    expect(response.body).to eql('You can delete only your own posts.')
  end
  it 'when user is trying to delete non-existing post' do
    login(@user)
    headers = get_auth_params_from_login_response_headers(response)
    delete api_post_path(10000), headers: headers
    expect(response.body).to eql('Post does not exist.')
    expect(response).to have_http_status(404)
  end
  end

  def fail_register(email,pass)
    post api_user_registration_path, :params => {email:email, password:pass}
  end
  def login(object)
    post api_user_session_path, params:  { email: object.email, password: '123456789' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end
end
