class AlterParentsTable < ActiveRecord::Migration

  def up
    add_column('parents', 'rel_with_student', :string)
  end

  def down
    remove_column('parents', 'rel_with_student')
  end

end
