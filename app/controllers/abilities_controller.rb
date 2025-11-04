class AbilitiesController < ApplicationController
  def index
  end

  def show
    @ability = Ability.find(params[:id])
    @pokemons = @ability.pokemons
  end
end
