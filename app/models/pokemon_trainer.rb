class PokemonTrainer < ApplicationRecord
  belongs_to :pokemon
  belongs_to :trainer
end
