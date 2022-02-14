class AddZipCodetoStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :zip_code, :string, limit: 15
  end
end
