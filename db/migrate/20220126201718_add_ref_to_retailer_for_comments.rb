class AddRefToRetailerForComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :retailers, :comments, polymorphic: true, null: true
  end
end
