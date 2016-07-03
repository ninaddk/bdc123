class AlterNotifications < ActiveRecord::Migration

  def up
    rename_column('notifications','date','due_date')
  end

  def down
    rename_column('notifications','due_date','date')
  end

end
