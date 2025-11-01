class PokemonAbility < ApplicationRecord
  belongs_to :pokemon
  belongs_to :ability

  validates :pokemon_id, uniqueness: { scope: :ability_id}
end
