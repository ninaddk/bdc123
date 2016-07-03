class AlterUserTableForResetPassword < ActiveRecord::Migration

  def up
    add_column('users', 'password_reset', :string, :after => 'password_digest')
  end

  def down
    remove_column('users', 'password_reset')
  end

end
