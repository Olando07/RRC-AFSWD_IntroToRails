class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.order(:name).page(params[:page]).per(20)
  end

  def search
    query = params[:query].to_s.downcase
    @pokemons= Pokemon.where("LOWER(name) LIKE ?", "%#{query}%").limit(10)

    render json: @pokemons.map { |p|
      {
        id: p.id,
        name: p.name,
        sprite_url: p.sprite_url
      }
    }
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @types = @pokemon.types
    @abilities = @pokemon.abilities
    @trainers = @pokemon.trainers
  end
end
