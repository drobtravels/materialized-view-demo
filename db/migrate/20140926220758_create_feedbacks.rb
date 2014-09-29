class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :talk_id
      t.text :comment
      t.integer :score

      t.timestamps
    end
  end
end
