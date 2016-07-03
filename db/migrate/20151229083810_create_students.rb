class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer 'day_care_center_id'
      t.string 'name'
      t.date 'dob'
      t.datetime 'enroll_date'
      t.datetime 'activation_date'
      t.datetime 'deactivation_date'
      t.string 'primary_contact_number'
      t.string 'preferred_contact_number'
      t.string 'food_preference'
      t.string 'ethnicity'
      t.string 'allergies'
      t.string 'medical_conditions'
      t.timestamps
    end
  end
end
