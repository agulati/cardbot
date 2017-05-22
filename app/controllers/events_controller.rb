class EventsController < ApplicationController

  before_action :verify_challenge, if: :has_challenge_param?
  before_action :own_message?

  def create
    if params[:event] && params[:event][:type] == "message"
      result = ActionParser.act_on( params[:event][:text], params[:event][:channel] )
    end

    render json: result
  end

  private

  def has_challenge_param?
    !!params[:challenge]
  end

  def verify_challenge
    render json: { challenge: params[:challenge] }
  end

  def own_message?
    render json: {} if params[:event] && params[:event][:username] == "GameBot"
  end
end
