class CreateAbilities < ActiveRecord::Migration[8.0]
  def change
    create_table :abilities do |t|
      t.string :name
      t.text :effect

      t.timestamps
    end
  end
end
