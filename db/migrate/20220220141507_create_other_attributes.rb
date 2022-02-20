class CreateOtherAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :other_attributes, id: {type: :bigint, unsigned: true} do |t|
      t.references :attributable, polymorphic: true, null: false, type: :bigint, unsigned: true
      t.json :data
    end
  end
end
