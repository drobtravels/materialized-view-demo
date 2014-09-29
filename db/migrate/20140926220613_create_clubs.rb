class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.integer :city_id
      t.integer :technology_id

      t.timestamps
    end
  end
end
