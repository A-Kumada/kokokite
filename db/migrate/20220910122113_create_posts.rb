class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, :null => false
      t.integer :category_id, :null => false
      t.string :title, :null => false
      t.text :outline, :null => false
      t.string :necessaries, :null => false
      t.text :point, :null => false

      t.timestamps
    end
  end
end
