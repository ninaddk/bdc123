class DayCareCenter < ActiveRecord::Base

  belongs_to :day_care

  validates_presence_of :name

  def as_json(options={})
    methods = [:day_care]
    super({methods: methods})
  end
end
