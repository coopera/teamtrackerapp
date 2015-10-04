class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :message
      t.string :organization
      t.string :author
      t.string :sha
      t.string :repository
      t.datetime :date

      t.timestamps null: false
    end
  end
end
