class Trainer < ApplicationRecord
  has_many :pokemon_trainers, dependent: :destroy
  has_many :pokemons, through: :pokemon_trainers

  validates :name, presence: true
end
