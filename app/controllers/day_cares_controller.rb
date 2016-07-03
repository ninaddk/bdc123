class DayCaresController < ApplicationController

  before_action :allow_if_admin_or_super_admin_logged_in

  def index
    @dayCares = DayCare.all
  end

  def new

  end

  def edit
    @dayCare = DayCare.find(params[:id])
  end

  def save
    unless has_sufficient_params(['name','url_name','zipcode'])
      return
    end

    dayCare = params[:id].to_i > 0 ? DayCare.find(params[:id]) : DayCare.new
    dayCare.assign_attributes(name: params[:name], address: params[:address], zipcode: params[:zipcode], url_name: params[:url_name])

    if dayCare.save
      render_result_json dayCare
    else
      render_error_json dayCare.errors.full_messages.first
    end
  end

  def delete
    delete_all_associated_data params[:id]
  end

  private

  def delete_all_associated_data id
    dayCare = DayCare.find(params[:id])
    unless dayCare
      render_success_json 'Error'
      return
    end

    dayCareCenter = DayCareCenter.where(day_care_id: dayCare.id)
    userRoles = UserRole.where('day_care_id = ? OR day_care_center_id in (?)', dayCare.id, dayCareCenter.pluck(:id))
    users = User.where(id: userRoles.pluck(:user_id))
    students = Student.where(day_care_center_id: dayCareCenter.pluck(:id))
    parents = Parent.where(student_id: students.pluck(:id))
    activities = Activity.where(student_id: students.pluck(:id))
    notification = Notification.where(day_care_center_id: dayCareCenter.pluck(:id))


    notification.delete_all
    activities.delete_all
    parents.delete_all
    students.delete_all
    users.delete_all
    userRoles.delete_all
    dayCareCenter.delete_all
    dayCare.destroy

    render_success_json 'Successfully'
  end

end
