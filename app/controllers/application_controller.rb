class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :basic if: -> { Rails.env.production? }

  private

  def basic
    authenticate_or_request_with_http_basic do |user, password|
      user == 'matsuerb' && password == 'procon'
    end
  end
end
