class AlterStudents < ActiveRecord::Migration

  def up
    add_column('students', 'pick_up_time', :datetime, :after => 'preferred_contact_number')
  end

  def down
    remove_column('students', 'pick_up_time')
  end

end
