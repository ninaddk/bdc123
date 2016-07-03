class AlterStudentsAndTeachers < ActiveRecord::Migration

  def up
    add_column('students', 'classroom_type', :integer, :after => 'day_care_center_id')
    add_column('user_roles', 'classroom_type', :integer, :after => 'role_id')
  end

  def down
    remove_column('students', 'classroom_type')
    remove_column('user_roles', 'classroom_type')
  end

end
