class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string 'name'
      t.string 'username'
      t.string 'password_digest'
      t.string 'email'
      t.string 'contact_number'
      t.string 'address'
      t.string 'zipcode'
      t.timestamps
    end
  end
end
