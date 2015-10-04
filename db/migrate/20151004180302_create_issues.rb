class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :number
      t.string :repo
      t.string :organization
      t.string :state
      t.datetime :closed_at
      t.string :title
      t.text :body
      t.string :author
      t.datetime :date

      t.timestamps null: false
    end
  end
end
