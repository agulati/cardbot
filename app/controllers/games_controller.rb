class GamesController < ApplicationController

  def create
    @game = Game.new
    render json: { id: @game.id }
  end

  def turn
    @game = Game.find(params[:id])
    render json: @game.turn
  end
end
