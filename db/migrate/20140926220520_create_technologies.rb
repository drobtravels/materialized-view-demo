class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
