class ActivitiesController < ApplicationController

  before_action :allow_if_user_logged_in, except: [:list, :save]

  def index
    if is_admin_user
      puts Time.now
      @activities = Activity.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id)).where('time > ?', Time.now).order("time DESC")
      @students = Student.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id))
    else
      @activities = Activity.where(day_care_center_id: @day_care_center_id).where('time >= ?', Time.now).order("time ASC")
      @students = Student.where(day_care_center_id: @day_care_center_id)
    end

    @activityTypes = ENM_ACTIVITY_TYPE.get_all_values
  end

  def list
    unless has_sufficient_params(['student_id'])
      return
    end

    student = Student.where(id: params['student_id']).first
    if student == nil
      render_error_json 'Student does not exist'
      return false
    end

    from_date = params[:from_date].present? ? params[:from_date].to_time : Date.today()
    if params[:from_date].present? && !params[:to_date].present?
      to_date = from_date
    elsif params[:to_date].present?
      to_date = params[:to_date].to_time
    else
      to_date = Date.today()
    end

    activities = Activity.where(student_id: params[:student_id]).where('time >= ? and time < ?', from_date.beginning_of_day, to_date.end_of_day)
    render_result_json activities
  end

  def save
    unless has_sufficient_params(['activity_type_id', 'student_id'])
      return
    end

    unless check_in_enum_if_exists(ENM_ACTIVITY_TYPE, 'activity_type_id')
      return
    end

    student = Student.where(id: params['student_id']).first
    if student == nil
      render_error_json 'Student does not exist'
      return false
    end

    puts params[:time]

    time = params[:time].present? ? params[:time] : Time.now

    if params[:id].to_i > 0
      activity = Activity.find(params[:id])
    else
      activity = Activity.new
    end

    #Assign Attr
    activity.assign_attributes(activity_type_id: params[:activity_type_id], student_id: params[:student_id], day_care_center_id: student.day_care_center_id, time: time, comment: params[:comments])

    puts activity

    if activity.save
      render_result_json activity
    else
      render_error_json activity.errors.full_messages.first
    end

  end

  def delete
    activity = Activity.find(params[:id])
    activity.destroy
    render_success_json 'Successfully'
  end

end
