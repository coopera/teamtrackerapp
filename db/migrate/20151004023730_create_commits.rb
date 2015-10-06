class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :message
      t.string :organization
      t.string :author
      t.string :sha
      t.string :repo
      t.string :files_modified
      t.integer :additions
      t.integer :deletions
      t.integer :pr_number
      t.datetime :date

      t.timestamps null: false
    end
  end
end
