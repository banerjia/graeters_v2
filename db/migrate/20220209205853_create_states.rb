class CreateStates < ActiveRecord::Migration[7.0]
  def up
    create_table :states do |t|
      t.string :state_code, limit: 2
      t.string :country_code, limit: 2

    end

    execute <<-SQL
      ALTER TABLE `states`
        MODIFY COLUMN `id` INT UNSIGNED AUTO_INCREMENT
    SQL

    add_index :states, [:country_code, :state_code], unique: true, order: { country_code: :desc, state_code: :asc}
  end

  def down
    drop_table :states
  end

end
