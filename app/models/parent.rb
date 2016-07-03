require 'securerandom'
class Parent < ActiveRecord::Base

  has_many :parent_student_relations
  has_many :students, :through => :parent_student_relations

  validates_presence_of :name
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password_digest
  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password

  def self.create_new (name, username, password, password_confirmation, email, contact_number, address, zipcode)
    return self.create(name: name, username: username, password: password, password_confirmation: password_confirmation, email: email, contact_number: contact_number, address: address, zipcode: zipcode)
  end

  def students_with_relations
    new_students = []
    students.each do |student|
      relation = ''
      parent_student_relations.each do |rel|
        relation = rel.relation_with_student if rel.student_id == student.id
      end
      new_students << {id: student.id, name: student.name, rel: relation}
    end

    return new_students
  end

  def thumb_image
    return 'https://bloom-dc.herokuapp.com/media/parent/thumb/1.jpg'
  end

  def preview_image
    return 'https://bloom-dc.herokuapp.com/media/parent/preview/1.jpg'
  end

  def as_json(options={})
    methods = [:thumb_image, :preview_image, :students, :parent_student_relations]
    super({methods: methods})
  end
end
