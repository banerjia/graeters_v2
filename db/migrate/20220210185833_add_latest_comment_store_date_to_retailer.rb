class AddLatestCommentStoreDateToRetailer < ActiveRecord::Migration[7.0]
  def change

    # Add Columns
    add_column :retailers, :latest_comment_date, :datetime 
    add_column :retailers, :latest_store_add_date, :datetime 

    # Add Indices
    add_index :retailers, [:active, :latest_comment_date], order: {active: :desc, latest_comment_date: :desc}
    add_index :retailers, [:active, :latest_store_add_date], order: {active: :desc, latest_store_add_date: :desc}
    
  end
end
