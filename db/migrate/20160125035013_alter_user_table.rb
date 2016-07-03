class AlterUserTable < ActiveRecord::Migration

  def up
    add_column('users', 'email', :string, :after => 'name')
  end

  def down
    remove_column('users', 'email')
  end


end
