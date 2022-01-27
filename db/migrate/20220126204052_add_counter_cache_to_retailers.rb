class AddCounterCacheToRetailers < ActiveRecord::Migration[7.0]
  def up
    add_column :retailers, :comments_count, :integer, default: 0

    execute <<-SQL
      ALTER TABLE retailers 
        MODIFY COLUMN comments_count INT UNSIGNED NOT NULL DEFAULT 0
    SQL
  end

  def def down 
    remove_column :retailers, :comments_count
  end
end
