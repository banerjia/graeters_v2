class CreateStores < ActiveRecord::Migration[7.0]

  def up
    create_table :stores do |t|
      t.references :retailer, null: false, unsigned: true, foreign_key: true, type: :integer
      t.references :state, null: false, unsigned: true, foreign_key: true, type: :integer
      t.string :name, limit: 128
      t.string :addr_ln_1, limit: 255
      t.string :addr_ln_2, limit: 255
      t.string :city, limit: 128
      t.float :latitude
      t.float :longitude
      t.boolean :active, default: true, null: false
      t.integer :comments_count, default: 0, null: false

      t.timestamps
    end

    #add_reference :stores, :retailer, foreign_key: true, unsigned: true, type: :integer
    #add_reference :stores, :state, foreign_key: true, unsigned: true, type: :integer

    execute <<-SQL
      ALTER TABLE `stores`
        MODIFY COLUMN `id` BIGINT UNSIGNED AUTO_INCREMENT,
        MODIFY COLUMN `active` tinyint default 1,
        MODIFY COLUMN `comments_count` INT UNSIGNED NOT NULL DEFAULT 0
    SQL

    add_index :stores, [:active, :retailer_id, :id], order: {active: :desc}

  end

  def down
    drop_table :stores
  end

end
