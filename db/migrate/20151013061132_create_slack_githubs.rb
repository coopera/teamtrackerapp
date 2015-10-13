class CreateSlackGithubs < ActiveRecord::Migration
  def change
    create_table :slack_githubs do |t|
      t.string :github
      t.string :slack
      t.string :organization

      t.timestamps null: false
    end
  end
end
