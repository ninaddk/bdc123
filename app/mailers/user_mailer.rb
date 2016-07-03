class UserMailer < ApplicationMailer

  default from: 'pankaj.chavan90@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def register(user, password)
    @user = user
    @user_role = USER_ROLE_NAMES[@user.user_role.role_id]

    if @user.user_role.day_care.present?
      @day_care = @user.user_role.day_care.name
    end

    if @user.user_role.day_care_center.present?
      @day_care_center = @user.user_role.day_care_center.name
    end

    @password = password
    mail(to: @user.email, subject: 'Welcome to Bloom!')
  end

  def register_parent(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Welcome to Bloom!')
  end

  def forgot_password(user, key, url)
    @user = user
    @key = key
    @url = url
    mail(to: @user.email, subject: 'Password change request for your Bloom account.')
  end

  def reset_password(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Reset password for your Bloom account')
  end

end
