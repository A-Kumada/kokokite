class AddStatusToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :status, :integur, null: false, default: 0
  end
end