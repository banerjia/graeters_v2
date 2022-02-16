class CreateStoreAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :store_attributes, id: false do |t|
      t.references :store, null: false,  foreign_key: true, type: :bigint, unsigned: true
      t.json :attr
    end

  end
end
