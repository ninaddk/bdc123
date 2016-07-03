class Activity < ActiveRecord::Base

  belongs_to :day_care_center

  validates_presence_of :day_care_center_id
  validates_presence_of :activity_type_id
  validates_presence_of :student_id
  validates_presence_of :time


  def title
    return ENM_ACTIVITY_TYPE.get_name_by_id activity_type_id
  end

  def student_name
    student = Student.select('name').where(:id => student_id).first
    if student.present?
      return student.name
    end
    return ''
  end

  def student_image_thumb
    student = Student.where(:id => student_id).first
    if student.present?
      return student.thumb_image.gsub('http://','https://')
    end
    return nil
  end

  def as_json(options={})
    methods = [:title, :student_name, :student_image_thumb]
    super({methods: methods})
  end

end
