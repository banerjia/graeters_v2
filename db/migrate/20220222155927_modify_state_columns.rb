class ModifyStateColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :states, :state_code, :code
    rename_column :states, :state_name, :name
  end
end
