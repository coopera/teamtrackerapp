class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.datetime :date
      t.string :author
      t.text :body
      t.string :repo
      t.string :organization
      t.integer :number

      t.timestamps null: false
    end
  end
end
