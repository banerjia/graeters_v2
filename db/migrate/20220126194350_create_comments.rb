class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body

      t.timestamps
    end

    add_index :comments, [:created_at], order: {created: :desc}
    add_belongs_to :comments, :commentable, polymorphic: true
  end
end
