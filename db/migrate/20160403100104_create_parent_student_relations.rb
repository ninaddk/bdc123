class CreateParentStudentRelations < ActiveRecord::Migration
  def change
    create_table :parent_student_relations do |t|
      t.references :parent
      t.references :student
      t.string :relation_with_student
      t.timestamps
    end
    add_index :parent_student_relations, ["parent_id", "student_id"]
  end
end
