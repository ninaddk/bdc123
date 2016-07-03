class Student < ActiveRecord::Base

  has_many :parent_student_relations
  has_many :parents, through: :parent_student_relations

  has_attached_file :image, styles: { preview: "420x630#", thumb: "350x350#" }, default_url: '/media/student/baby-icon.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :name
  validates_presence_of :dob
  validates_presence_of :primary_contact_number
  validates_presence_of :preferred_contact_number

  def parents_with_relations
      new_parents = []
      parents.each do |parent|
        relation = ''
        parent_student_relations.each do |rel|
          relation = rel.relation_with_student if rel.parent_id == parent.id
        end
        new_parents << {id: parent.id, name: parent.name, rel: relation}
      end

      return new_parents
  end

  def thumb_image
    if image_file_name == nil
      return '/media/student/baby-icon.png'
    end
    return image.url(:thumb).gsub('http://','https://')
  end

  def preview_image
    if image_file_name == nil
      return '/media/student/baby-icon.png'
    end
    return image.url(:preview).gsub('http://','https://')
  end

  def checked_in
    return Activity.where(student_id: id, activity_type_id: TEACHER_CHECK_IN).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).first
  end

  def checked_out
    return Activity.where(student_id: id, activity_type_id: TEACHER_CHECK_OUT).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).first
  end

  def last_fed
    return Activity.where(student_id: id, activity_type_id: [BREAKFAST_HOME, BREAKFAST_SCHOOL, LUNCH_HOME, LUNCH_SCHOOL, SNACKS_HOME, SNACKS_SCHOOL]).order("time DESC").first
  end

  def last_slept
    return Activity.where(student_id: id, activity_type_id: [NAP_TIME_MORNING, NAP_TIME_AFTERNOON, NAP_TIME_EVENING]).order("time DESC").first
  end

  def last_activity
    return Activity.where(student_id: id).order("time DESC").first
  end

  def as_json(options={})
    methods = [:thumb_image, :preview_image, :checked_in, :checked_out, :last_fed, :last_slept, :last_activity, :parents_with_relations]
    super({methods: methods})
  end

end
