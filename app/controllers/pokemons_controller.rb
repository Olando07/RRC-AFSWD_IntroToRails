class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all.order("RANDOM()").limit(25)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @types = @pokemon.types
    @abilities = @pokemon.abilities
    @trainers = @pokemon.trainers
  end
end
