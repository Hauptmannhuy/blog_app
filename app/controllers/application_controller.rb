class ApplicationController < ActionController::Base
 protect_from_forgery with: :exception, if: :verify_from_api

 def verify_from_api
  params[:controller].split('/')[0] != 'devise_token_auth'
 end
end
