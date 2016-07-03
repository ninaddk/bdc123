class BranchAdminsController < ApplicationController

  before_action :allow_if_admin_or_super_admin_logged_in

  def index
    if @user_id == -1
      user_roles = UserRole.where(role_id: USER_ROLE_BRANCH_ADMIN)
      @dayCareCenter = DayCareCenter.all
    else
      user_roles = UserRole.where(day_care_id: @day_care_id, role_id: USER_ROLE_BRANCH_ADMIN)
      @dayCareCenter = DayCareCenter.where(day_care_id: @day_care_id)
    end

    @branchAdmins = User.where(id: user_roles.pluck(:user_id))
  end

  def new
    @user = User.new()
    @dayCareCenter = DayCareCenter.where(day_care_id: @day_care_id)
  end

  def save
    unless has_sufficient_params(['name','email','username','day_care_center_id'])
      return
    end

    day_care_center = DayCareCenter.where(id: params[:day_care_center_id]).first
    unless day_care_center
      render_error_json 'DayCareCenterId can not be blank'
      return
    end

    if params[:id].to_i > 0
      branch_admin = User.find(params[:id])
      branch_admin.name = params[:name]
      branch_admin.email = params[:email]
    else
      branch_admin = User.create_new(params[:name],params[:email],params[:username],params[:password],params[:confirm_password])
    end

    if branch_admin.save
      user_role = UserRole.find_by_user_id(branch_admin.id)
      if user_role == nil
        UserRole.create(user_id: branch_admin.id, day_care_id: day_care_center.day_care_id, day_care_center_id: day_care_center.id, role_id: USER_ROLE_BRANCH_ADMIN)
      else
        user_role.day_care_center_id = params[:day_care_center_id]
        user_role.save
      end

      unless params[:id].to_i > 0
        UserMailer.register(branch_admin, params[:password]).deliver_now
      end

      render_result_json branch_admin
    else
      render_error_json branch_admin.errors.full_messages.first
    end
  end

  def edit
    @user = User.find(params[:id])
    @dayCareCenter = DayCareCenter.where(day_care_id: @day_care_id)
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
      userRole.day_care_center_id = params[:day_care_center_id]
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
    branch_admin = User.find(params[:id].to_i)
    branch_admin.destroy

    userRole = UserRole.find_by_user_id(branch_admin.id)
    userRole.destroy

    render_success_json 'Success'
  end

end
