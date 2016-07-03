class AlterParents < ActiveRecord::Migration

  def up
    add_column('parents', 'student_id', :integer)
    add_index('parents', 'student_id')
  end

  def down
    remove_index('parents', 'student_id')
    remove_column('parents', 'student_id')
  end

end
