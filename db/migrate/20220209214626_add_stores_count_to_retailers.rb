class AddStoresCountToRetailers < ActiveRecord::Migration[7.0]
  def up
    add_column :retailers, :stores_count, :integer, null: false, default: 0

    execute <<-SQL
      ALTER TABLE `retailers`
        MODIFY COLUMN `stores_count` INT UNSIGNED DEFAULT 0 NOT NULL
    SQL

  end

  def down
    remove_column :retailers, :stores_count
  end
end
