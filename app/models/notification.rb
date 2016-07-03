class Notification < ActiveRecord::Base

  belongs_to :day_care_center

  validates_presence_of :day_care_center_id
  validates_presence_of :name
  validates_presence_of :due_date
  validate :is_past_due_date
  validate :is_past_reminder_date

  def is_past_due_date
    errors.add(:due_date, "can't be past") if !due_date.blank? && due_date <= Date.today
  end

  def is_past_reminder_date
    errors.add(:reminder_date, "can't be past") if !reminder_date.blank? && reminder_date <= Date.today
  end

  def as_json(options={})
    methods = [:day_care_center]
    super({methods: methods})
  end

end
