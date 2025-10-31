class CreateTrainers < ActiveRecord::Migration[8.0]
  def change
    create_table :trainers do |t|
      t.string :name
      t.string :hometown

      t.timestamps
    end
  end
end
