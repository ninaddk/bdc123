class UserRole < ActiveRecord::Base

  belongs_to :user
  belongs_to :day_care
  belongs_to :day_care_center

  validates_presence_of :user_id

  def as_json options=nil
    return super({methods: [:day_care, :day_care_center]})
  end

end
