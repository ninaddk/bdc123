class DashboardController < ApplicationController

  before_action :allow_if_admin_or_super_admin_logged_in, except: [:branch_admin]
  before_action :allow_if_user_logged_in, only: [:branch_admin]

  def index
    dayCare = DayCare.all
    arr = []
    dayCare.each do |content|
      student = Student.where(day_care_center_id: DayCareCenter.where(day_care_id: content.id).pluck(:id))
      student_check_in = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_IN]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
      student_check_out = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_OUT]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count

      arr << [content['name'], student.count, student_check_in, student_check_out]
    end

    @dataPoints = arr
    student = Student.all
    @students_count = student.count
    @students_check_in_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_IN]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @students_check_out_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_OUT]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @notifications = Notification.where('due_date >= ? and due_date < ?', Date.today().beginning_of_day, Date.today().end_of_day)
    @activities = Activity.where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day)
  end

  def admin
    dayCareCenters = DayCareCenter.where(day_care_id: @day_care_id)

    arr = []

    dayCareCenters.each do |content|
      student = Student.where(day_care_center_id: content.id)
      student_check_in = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_IN]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
      student_check_out = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_OUT]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count

      arr << [content['name'], student.count, student_check_in, student_check_out]
    end

    @dataPoints = arr
    student = Student.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id))
    @students_count = student.count
    @students_check_in_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_IN]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @students_check_out_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_OUT]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @notifications = Notification.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id)).where('due_date >= ?', Time.now()).limit(5)
    @activities = Activity.where(day_care_center_id: DayCareCenter.where(day_care_id: @day_care_id).pluck(:id)).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).limit(5)
  end

  def branch_admin
    student = Student.where(day_care_center_id: @day_care_center_id)
    @students_count = student.count
    @students_check_in_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_IN]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @students_check_out_count = Activity.where(student_id: student.pluck(:id), activity_type_id: [TEACHER_CHECK_OUT]).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).count
    @notifications = Notification.where(day_care_center_id: @day_care_center_id).where('due_date >= ?', Time.now).limit(5)
    @activities = Activity.where(day_care_center_id: @day_care_center_id).where('time >= ? and time < ?', Date.today().beginning_of_day, Date.today().end_of_day).limit(5)
  end

end
