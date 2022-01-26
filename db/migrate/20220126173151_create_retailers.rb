class CreateRetailers < ActiveRecord::Migration[7.0]
  def up
    create_table :retailers do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE retailers 
        MODIFY COLUMN id INT UNSIGNED AUTO_INCREMENT
    SQL

    add_index :retailers, [:active, :id, :url]
    add_index :retailers, :url, unique: true

  end

  def down
    drop_table :retailers
  end
end
