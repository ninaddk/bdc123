class AlterStudentsTable < ActiveRecord::Migration

  def up
    add_column('students', 'day_care_id', :integer, :after => 'id')
  end

  def down
    remove_column('students', 'day_care_id')
  end

end
