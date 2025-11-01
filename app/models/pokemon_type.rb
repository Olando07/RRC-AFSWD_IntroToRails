class PokemonType < ApplicationRecord
  belongs_to :pokemon
  belongs_to :type

  validates :pokemon_id, uniqueness: { scope: :type_id}
end
