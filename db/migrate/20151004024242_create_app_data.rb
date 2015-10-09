class CreateAppData < ActiveRecord::Migration
  def change
    create_table :app_data do |t|
      t.datetime :last_updated
      t.string :organization

      t.timestamps null: false
    end
  end
end
