class CreateDayCareCenters < ActiveRecord::Migration
  def change
    create_table :day_care_centers do |t|
      t.string 'name'
      t.integer 'day_care_id'
      t.string 'address'
      t.string 'zipcode'
      t.timestamps
    end
  end
end
