class EventsController < ApplicationController

  before_action :verify_challenge, if: :has_challenge_param?

  def create
    ActionParser.act_on( params[:event][:text] ) if params[:event] && params[:event][:type] == "message"
    render json: {}
  end

  private

  def has_challenge_param?
    !!params[:challenge]
  end

  def verify_challenge
    render json: { challenge: params[:challenge] }
  end
end
