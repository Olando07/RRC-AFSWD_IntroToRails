class Pokemon < ApplicationRecord
  has_many :pokemon_types, dependent: :destroy
  has_many :types, through: :pokemon_types

  has_many :pokemon_abilities, dependent: :destroy
  has_many :abilities, through: :pokemon_abilities

  has_many :pokemon_trainers, dependent: :destroy
  has_many :trainers, through: :pokemon_trainers

  validates :name, presence: true, uniqueness: true
  validates :latitude, :longitude, presence: true
  validates :height, :weight, numericality: { greater_than: 0 }, allow_nil: true
end
