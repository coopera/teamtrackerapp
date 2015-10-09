class CreateSlackMessages < ActiveRecord::Migration
  def change
    create_table :slack_messages do |t|
      t.string :author
      t.string :organization
      t.text :text
      t.datetime :date
      t.string :channel

      t.timestamps null: false
    end
  end
end
