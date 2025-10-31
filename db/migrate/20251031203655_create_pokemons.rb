class CreatePokemons < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :height
      t.integer :weight
      t.integer :base_experience
      t.string :sprite_url

      t.timestamps
    end
  end
end
