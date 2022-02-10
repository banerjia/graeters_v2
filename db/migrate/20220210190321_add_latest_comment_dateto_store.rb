class AddLatestCommentDatetoStore < ActiveRecord::Migration[7.0]
  def change

    # Columns
    add_column :stores, :latest_comment_date, :datetime

    # Indexes
    add_index :stores, [:active, :retailer_id, :latest_comment_date], order: {active: :desc, retailer_id: :asc, latest_comment_date: :desc}
    add_index :stores, [:active, :retailer_id, :updated_at], order: {active: :desc, updated_at: :desc}

  end
end
