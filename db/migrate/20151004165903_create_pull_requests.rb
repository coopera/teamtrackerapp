class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.string :state
      t.string :title
      t.text :body
      t.integer :number
      t.datetime :merged_at
      t.datetime :closed_at
      t.string :repo
      t.string :organization
      t.string :author
      t.datetime :date

      t.timestamps null: false
    end
  end
end
