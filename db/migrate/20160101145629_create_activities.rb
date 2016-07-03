class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer 'activity_type_id'
      t.integer 'student_id'
      t.datetime 'time'
      t.string 'comment'
      t.timestamps
    end
  end
end
