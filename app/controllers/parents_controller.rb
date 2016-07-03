class ParentsController < ApplicationController

  before_action :allow_if_user_logged_in, except: [:login, :get_profile, :edit_profile, :reset_password]
  before_action :is_branch_admin_user, except: [:login, :get_profile, :edit_profile, :reset_password]

  def index
      if is_admin_user
        @students = Student.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id))
      else
        @students = Student.where(day_care_center_id: @day_care_center_id)
      end
  end

  def list
    parents = Parent.all
    render_result_json parents
  end

  def save
    unless has_sufficient_params(['name','username','email'])
      return
    end

    if params[:id].to_i > 0
      parent = Parent.find(params[:id])
      parent.assign_attributes(name: params[:name], email: params[:email], contact_number: params[:contact_number], address: params[:address], zipcode: params[:zipcode])
    else
      parent = Parent.create_new(params[:name], params[:username], params[:password], params[:confirm_password], params[:email], params[:contact_number], params[:address], params[:zipcode])
    end

    if parent.save

      unless params[:id].to_i > 0
        #UserMailer.register_parent(parent, params[:password]).deliver_now
      end

      render_result_json parent
    else
      render_error_json parent.errors.full_messages.first
    end
  end

  def delete
    parent = Parent.find(params[:id].to_i)
    parent.destroy

    render_success_json 'Success'
  end

  def login
    unless has_sufficient_params(['username','password'])
      return
    end

    if params[:username].present? && params[:password].present?
      found_parent = Parent.where(username: params[:username]).first
      if found_parent
        authorized_parent = found_parent.authenticate(params[:password])
      end
    end

    if authorized_parent
      render_result_json found_parent
    else
      render_error_json 'Wrong username or password'
    end
  end

  def get_profile
    unless has_sufficient_params(['id'])
      return
    end

    parent = Parent.find_by_id(params[:id])
    render_result_json parent
  end

  def edit_profile
    unless has_sufficient_params(['id'])
      return
    end

    if params[:id].to_i > 0
      parent = Parent.where(id: params[:id]).first
    end

    unless parent
      render_error_json "Couldn't able to find parent"
      return
    end

    parent.assign_attributes(name: params[:name], contact_number: params[:contact_number], address: params[:address], zipcode: params[:zipcode])
    if parent.save
      render_result_json parent
    else
      render_error_json parent.errors.full_messages.first
    end
  end

  def reset_password
    unless has_sufficient_params(['username','old_password','new_password','confirm_new_password'])
      return
    end

    if params[:username].present? && params[:old_password].present?
      found_parent = Parent.where(username: params[:username]).first

      if found_parent
        authorized_parent = found_parent.authenticate(params[:old_password])
      end
    end

    if authorized_parent
      found_parent.password = params[:new_password]
      found_parent.password_confirmation = params[:confirm_new_password]

      if found_parent.save
        #UserMailer.reset_password(found_parent, params[:new_password]).deliver_now
        render_result_json 'success'
      else
        render_error_json found_parent.errors.full_messages.first
      end
    else
      render_error_json 'Wrong username or password'
    end
  end

  def student_relation
    parent = params[:parent_id].to_i
    unless parent > 0
      render_error_json 'Error'
      return
    end

    students = params[:related_students]
    unless students
      render_error_json 'Please select at least a child'
      return
    end

    ParentStudentRelation.where(parent_id: parent).delete_all

    students.each_key do |key|
      rel = ParentStudentRelation.find_or_create_by(parent_id: parent, student_id: key)
      rel.update_attributes(relation_with_student: students[key])
    end

    render_success_json 'Success'
  end

end
