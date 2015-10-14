class CreateAppData < ActiveRecord::Migration
  def change
    create_table :app_data do |t|
      t.datetime :gh_last_updated
      t.datetime :slack_last_updated
      t.string :last_slack_ts
      t.string :slack_token
      t.string :organization

      t.timestamps null: false
    end
  end
end
