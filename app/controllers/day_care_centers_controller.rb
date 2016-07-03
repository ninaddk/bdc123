class DayCareCentersController < ApplicationController

  before_action :allow_if_admin_or_super_admin_logged_in

  def index
    @dayCare = DayCare.all

    if @user_id == -1
      @dayCareCenters = DayCareCenter.all
    else
      @dayCareCenters = DayCareCenter.where(day_care_id: @day_care_id)
    end
  end

  def new

  end

  def edit
    @dayCareCenter = DayCareCenter.find(params[:id])
  end

  def save
    unless has_sufficient_params(['name','day_care'])
      return
    end

    day_care = DayCare.where(id: params[:day_care]).first
    unless day_care
      render_error_json 'DayCareId can not be blank'
      return
    end

    dayCareCenter = params[:id].to_i > 0 ? DayCareCenter.find(params[:id]) : DayCareCenter.new
    dayCareCenter.assign_attributes(name: params[:name], day_care_id: day_care.id, address: params[:address], zipcode: params[:zipcode])

    if dayCareCenter.save
      render_result_json dayCareCenter
    else
      render_error_json dayCareCenter.errors.full_messages.first
    end
  end

  def delete
    delete_all_associated_data params[:id]
  end

  private

  def delete_all_associated_data id
    dayCareCenter = DayCareCenter.find(params[:id])
    unless dayCareCenter
      render_success_json 'Error'
      return
    end

    userRoles = UserRole.where(day_care_center_id: dayCareCenter.id)
    users = User.where(id: userRoles.pluck(:user_id))
    students = Student.where(day_care_center_id: dayCareCenter.id)
    parents = Parent.where(student_id: students.pluck(:id))
    activities = Activity.where(student_id: students.pluck(:id))
    notification = Notification.where(day_care_center_id: dayCareCenter.id)

    notification.delete_all
    activities.delete_all
    parents.delete_all
    students.delete_all
    users.delete_all
    userRoles.delete_all
    dayCareCenter.destroy

    render_success_json 'Successfully'
  end

end
