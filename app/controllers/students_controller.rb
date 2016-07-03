class StudentsController < ApplicationController

  before_action :allow_if_user_logged_in, except: [:get_profile, :edit_profile, :list]

  def index
    @student = Student.new
    if is_admin_user
      @students = Student.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id))
    else
      @students = Student.where(day_care_center_id: @day_care_center_id)
    end

    @classroomType = ENM_CLASSROOM_TYPE.get_all_values
    @dayCareCenters = DayCareCenter.where(day_care_id: @day_care_id)
    @parents = Parent.all
  end

  def save
    unless has_sufficient_params(['day_care_center','name','dob','primary_contact_number','preferred_contact_number'])
      return
    end

    day_care_center = DayCareCenter.where(id: params[:day_care_center]).first
    unless day_care_center
      render_error_json 'DayCareCenterId can not be blank'
      return
    end

    if params[:id].to_i > 0
      student = Student.find(params[:id])
    else
      student = Student.new
      student.enroll_date = Time.now
    end

    dob = params[:dob].present? ? params[:dob].to_date : ''
    student.assign_attributes(day_care_id: @day_care_id, day_care_center_id: day_care_center.id, name: params[:name], dob: dob, classroom_type: params[:classroom_type], pick_up_time: params[:pick_up_time], primary_contact_number: params[:primary_contact_number], preferred_contact_number: params[:preferred_contact_number], food_preference: params[:food_preference], ethnicity: params[:ethnicity], allergies: params[:allergies], medical_conditions: params[:medical_conditions])

    if student.save
      render_result_json student
    else
      render_error_json student.errors.full_messages.first
    end
  end

  def upload_image
    if !params[:image].present?
      flash[:error] = 'Please choose an image file'
      redirect_to action: :index, upload_image: 'error', upload_image_id: params[:image_student_id]
      return
    end

    student = Student.find(params[:image_student_id])
    student.image = params[:image]
    if student.save
      redirect_to action: :index
    else
      redirect_to action: :index, upload_image: 'error'
    end
  end

  def delete
    student = Student.find(params[:id])
    student.destroy

    render_success_json 'Success'
  end

  def get_profile
    unless has_sufficient_params(['id'])
      return
    end

    student = Student.find_by_id(params[:id])
    render_result_json student
  end

  def edit_profile
    unless has_sufficient_params(['id'])
      return
    end

    if params[:id].to_i > 0
      student = Student.where(id: params[:id]).first
    end

    unless student
      render_error_json "Couldn't able to find student"
      return
    end

    dob = params[:dob].present? ? params[:dob].to_date : ''
    student.assign_attributes(name: params[:name], dob: dob, pick_up_time: params[:pick_up_time], primary_contact_number: params[:primary_contact_number], preferred_contact_number: params[:preferred_contact_number], food_preference: params[:food_preference], ethnicity: params[:ethnicity], allergies: params[:allergies], medical_conditions: params[:medical_conditions])

    if student.save
      render_result_json student
    else
      render_error_json student.errors.full_messages.first
    end
  end

  def list
    unless has_sufficient_params(['teacher_id'])
      return
    end

    teacher = User.find_by_id(params[:teacher_id])
    if teacher == nil
      render_error_json 'Teacher Dose not exist'
      return false
    end

    user_role = UserRole.where(user_id: teacher.id, role_id: USER_ROLE_TEACHER).first
    if user_role == nil
      render_error_json 'Teacher Dose not exist'
      return false
    end

    students = Student.where(day_care_center_id: user_role.day_care_center_id)
    render_result_json students
  end

  def parent_relation
    student_id = params[:student_id].to_i
    unless student_id > 0
      render_error_json 'Error'
      return
    end

    parents = params[:related_parents]
    unless parents
      render_error_json 'Please select at least a parent'
      return
    end

    ParentStudentRelation.where(student_id: student_id).delete_all

    parents.each_key do |key|
      rel = ParentStudentRelation.create(student_id: student_id, parent_id: key)
      rel.update_attributes(relation_with_student: parents[key])
    end

    render_success_json 'Success'
  end

end
