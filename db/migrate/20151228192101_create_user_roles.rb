class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer 'user_id'
      t.integer 'day_care_id'
      t.integer 'day_care_center_id'
      t.integer 'role_id'
      t.timestamps
    end
  end
end
