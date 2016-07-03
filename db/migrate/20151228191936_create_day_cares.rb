class CreateDayCares < ActiveRecord::Migration
  def change
    create_table :day_cares do |t|
      t.string 'name'
      t.string 'address'
      t.string 'zipcode'
      t.string 'url_name'
      t.timestamps
    end
  end
end
