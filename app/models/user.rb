require 'securerandom'
class User < ActiveRecord::Base

  has_one :user_role

  validates_presence_of :name
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  #validates_uniqueness_of :email
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password_digest

  has_secure_password

  def self.create_new (name, email, username, password, password_confirmation)
    return self.create(name: name, email: email, username: username, password: password, password_confirmation: password_confirmation)
  end

  def thumb_image
    if user_role.role_id == USER_ROLE_TEACHER
      return 'https://bloom-dc.herokuapp.com/media/teacher/thumb/1.jpg'
    end
    return ''
  end

  def preview_image
    if user_role.role_id == USER_ROLE_TEACHER
      return 'https://bloom-dc.herokuapp.com/media/teacher/preview/1.jpg'
    end
    return ''
  end

  def as_json options=nil
    methods = [:thumb_image, :preview_image, :user_role]
    super({methods: methods})
  end
end
