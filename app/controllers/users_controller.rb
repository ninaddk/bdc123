class UsersController < ApplicationController

  before_action :allow_if_admin_or_super_admin_logged_in, except: [:change_password]

  def index
    user_roles = UserRole.where(role_id: USER_ROLE_ADMIN)
    @users = User.where(id: user_roles.pluck(:user_id))

    @daycare = DayCare.all
  end

  def new
    @user = User.new()
    @daycare = DayCare.all
  end

  def save
    unless has_sufficient_params(['name','email','username','day_care_id'])
      return
    end

    if params[:id].to_i > 0
      user = User.find(params[:id])
      user.name = params[:name]
      user.email = params[:email]
    else
      user = User.create_new(params[:name],params[:email],params[:username],params[:password],params[:confirm_password])
    end

    if user.save
      user_role = UserRole.find_by_user_id(user.id)
      if user_role == nil
        UserRole.create(user_id: user.id, day_care_id: params[:day_care_id], role_id: USER_ROLE_ADMIN)
      else
        user_role.day_care_id = params[:day_care_id]
        user_role.save
      end

      unless params[:id].to_i > 0
        UserMailer.register(user, params[:password]).deliver_now
      end

      render_result_json user
    else
      render_error_json user.errors.full_messages.first
    end
  end

  def edit
    @daycare = DayCare.all
    @user = User.find(params[:id])
  end

  def update
    if !params[:id].to_i.present?
      render_error_json 'Please specify the Id'
      return false
    end

    user = User.find(params[:id].to_i)
    user.name = params[:name]

    if user.save
      userRole = UserRole.find_by_user_id(user.id)
      userRole.day_care_id = params[:day_care]
      if userRole.save
        render_success_json 'Data Updated Successfully'
      else
        render_error_json userRole.errors.full_messages.first
      end
    else
      render_error_json user.errors.full_messages.first
    end
  end

  def delete
    user = User.find(params[:id].to_i)
    user.destroy

    userRole = UserRole.find_by_user_id(user.id)
    userRole.destroy

    render_success_json 'Success'
  end

  def change_password
    unless has_sufficient_params(['id','old_password','new_password','confirm_new_password'])
      return
    end

    found_user = User.where(id: params[:id]).first
    if found_user
      authorized_user = found_user.authenticate(params[:old_password])
    end

    unless authorized_user
      render_error_json 'Old password dose not match'
      return
    end

    found_user.password = params[:new_password]
    found_user.password_confirmation = params[:confirm_new_password]

    if found_user.save
      render_result_json 'success'
    else
      render_error_json found_user.errors.full_messages.first
    end
  end
end
