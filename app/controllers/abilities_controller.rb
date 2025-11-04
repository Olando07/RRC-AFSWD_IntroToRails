class AbilitiesController < ApplicationController
  def index
    @abilities = Ability.all
  end

  def show
    @ability = Ability.find(params[:id])
    @pokemons = @ability.pokemons
  end
end
