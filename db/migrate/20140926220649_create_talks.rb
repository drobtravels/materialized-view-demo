class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :name
      t.integer :author_id
      t.integer :club_id
      t.text :description
      t.timestamps
    end
  end
end
