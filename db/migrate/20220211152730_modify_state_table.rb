class ModifyStateTable < ActiveRecord::Migration[7.0]
  def change
    # Modify existing columns
    change_column :states, :state_code, :string, limit: 10, null: false, default: 'na'
    change_column :states, :country_code, :string, limit: 2, null: false, default: 'us'
    
    # Add new columns
    add_column :states, :state_name, :string, limit: 128, null: false, default: 'Undefined'
  end
end
