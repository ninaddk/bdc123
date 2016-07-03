class AddAttachmentImageToStudents < ActiveRecord::Migration
  def change
    add_attachment :students, :image
  end
end
