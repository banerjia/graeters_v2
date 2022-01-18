class CreateCompanies < ActiveRecord::Migration[7.0]
  def up
    create_table :companies do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE companies 
        MODIFY COLUMN id INT UNSIGNED AUTO_INCREMENT
    SQL

    add_index :companies, [:active, :id, :url]
    add_index :companies, :url, unique: true

  end

  def down
    drop_table :companies
  end
end
