class NotificationsController < ApplicationController

  before_action :allow_if_user_logged_in, except: [:list]

  def index
    if is_admin_user
      @notifications = Notification.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id)).where('due_date >= ?', Date.today().beginning_of_day).order("due_date ASC")
    else
      @notifications = Notification.where(day_care_center_id: @day_care_center_id).where('due_date >= ?', Date.today().beginning_of_day).order("due_date ASC")
    end

    @dayCareCenters = DayCareCenter.where(day_care_id: @day_care_id)
  end

  def save
    unless has_sufficient_params(['name','due_date','day_care_center'])
      return
    end

    day_care_center = DayCareCenter.where(id: params[:day_care_center]).first
    unless day_care_center
      render_error_json 'DayCareCenterId can not be blank'
      return
    end

    if params[:id].to_i > 0
      notification = Notification.find(params[:id])
    else
      notification = Notification.new
    end

    due_date = params[:due_date].present? ? params[:due_date].to_time : ''
    reminder_date = params[:reminder_date].present? ? params[:reminder_date].to_time : ''
    notification.assign_attributes(day_care_center_id: day_care_center.id, name: params[:name], due_date: due_date, reminder_date: reminder_date)

    if notification.save
      render_result_json notification
    else
      render_error_json notification.errors.full_messages.first
    end
  end

  def delete
    notification = Notification.find(params[:id])
    notification.destroy

    render_success_json 'Success'
  end

  def list
    unless has_sufficient_params(['day_care_center_id'])
      return
    end

    from_date = params[:from_date].present? ? params[:from_date].to_time : Date.today()
    if params[:from_date].present? && !params[:to_date].present?
      to_date = from_date
    elsif params[:to_date].present?
      to_date = params[:to_date].to_time
    else
      to_date = Date.today()
    end

    notification = Notification.where(day_care_center_id: params[:day_care_center_id]).where('due_date >= ? and due_date < ?', from_date.beginning_of_day, to_date.end_of_day)
    render_result_json notification
  end

end
