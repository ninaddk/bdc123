class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer 'day_care_center_id'
      t.string 'name'
      t.datetime 'date'
      t.datetime 'reminder_date'
      t.timestamps
    end
  end
end
