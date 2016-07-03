class TeachersController < ApplicationController

  before_action :allow_if_user_logged_in, except: [:login, :reset_password]

  def index
    if is_admin_user
      user_roles = UserRole.where(day_care_id: @day_care_id, role_id: USER_ROLE_TEACHER)
    else
      user_roles = UserRole.where(day_care_id: @day_care_id, day_care_center_id: @day_care_center_id, role_id: USER_ROLE_TEACHER)
    end

    @teachers = User.where(id: user_roles.pluck(:user_id))
    @classroomType = ENM_CLASSROOM_TYPE.get_all_values
    @dayCareCenters = DayCareCenter.where(day_care_id: @day_care_id)

  end

  def new

  end

  def save
    unless has_sufficient_params(['name','email','username','day_care_center'])
      return
    end

    if params[:id].to_i > 0
      teacher = User.find(params[:id])
      teacher.name = params[:name]
      teacher.email = params[:email]
    else
      teacher = User.create_new(params[:name],params[:email],params[:username],params[:password],params[:confirm_password])
    end

    if teacher.save
      user_role = UserRole.find_by_user_id(teacher.id)
      if user_role == nil
        UserRole.create(:user_id => teacher.id, :day_care_id => @day_care_id, :day_care_center_id => params[:day_care_center], role_id: USER_ROLE_TEACHER, classroom_type: params[:classroom_type])
      else
        user_role.classroom_type = params[:classroom_type]
        user_role.day_care_center_id = params[:day_care_center]
        user_role.save
      end

      unless params[:id].to_i > 0
        UserMailer.register(teacher, params[:password]).deliver_now
      end

      render_result_json teacher
    else
      render_error_json teacher.errors.full_messages.first
    end
  end


  def edit
    @teacher = User.find(params[:id])
  end

  def update
    if !params[:id].to_i.present?
      render_error_json 'Please specify the Id'
      return false
    end

    teacher = User.find(params[:id].to_i)
    teacher.name = params[:name]

    if teacher.save
        render_success_json 'Data Updated Successfully'
    else
      render_error_json teacher.errors.full_messages.first
    end
  end

  def delete
    teacher = User.find(params[:id].to_i)
    teacher.destroy

    userRole = UserRole.find_by_user_id(teacher.id)
    userRole.destroy

    render_success_json 'Success'
  end

  def login
    unless has_sufficient_params(['username','password'])
      return
    end

    if params[:username].present? && params[:password].present?
      found_teacher = User.where(username: params[:username]).first

      if found_teacher
          teacher_role = UserRole.where(user_id: found_teacher.id, role_id: USER_ROLE_TEACHER).first
      end

      if teacher_role
        authorized_teacher = found_teacher.authenticate(params[:password])
      else
        render_error_json 'User is not teacher'
        return false
      end
    end

    if authorized_teacher
      render_result_json found_teacher
    else
      render_error_json 'Wrong username or password'
    end
  end

  def reset_password
    unless has_sufficient_params(['username','old_password','new_password','confirm_new_password'])
      return
    end

    found_teacher = User.where(username: params[:username]).first
    if found_teacher
      teacher_role = UserRole.where(user_id: found_teacher.id, role_id: USER_ROLE_TEACHER).first
    end

    if teacher_role
      authorized_teacher = found_teacher.authenticate(params[:old_password])
    else
      render_error_json 'User is not teacher'
      return false
    end

    if authorized_teacher
      found_teacher.password = params[:new_password]
      found_teacher.password_confirmation = params[:confirm_new_password]

      if found_teacher.save
        #UserMailer.reset_password(found_teacher, params[:new_password]).deliver_now
        render_result_json 'success'
      else
        render_error_json found_teacher.errors.full_messages.first
      end
    else
      render_error_json 'Wrong username or password'
    end

  end

end
