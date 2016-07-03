class AlterActivities < ActiveRecord::Migration

  def up
    add_column('activities', 'day_care_center_id', :integer)
    add_index('activities', 'day_care_center_id')
  end

  def down
    remove_index('activities', 'day_care_center_id')
    remove_column('activities', 'day_care_center_id')
  end

end
