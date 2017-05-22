class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :verify_slack_token

  private

  def verify_slack_token
    render json: { error: "Invalid token" } unless params[:token] == $slack_config[:verification_token]
  end
end
