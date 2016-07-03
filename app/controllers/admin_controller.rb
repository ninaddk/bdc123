class AdminController < ApplicationController

  def index
    redirect_to action: 'login'
  end

  def login
      render 'login', layout: false
  end

  def auth
    if params[:username].present? && params[:password].present?
        found_user = User.where(username: params[:username]).first
        if found_user
          authorized_user = found_user.authenticate(params[:password])
        end
    end

    if authorized_user
      process_signin authorized_user

      if found_user.user_role.role_id == USER_ROLE_ADMIN
        redirect_to controller: 'dashboard', action: 'admin'

      elsif found_user.user_role.role_id == USER_ROLE_BRANCH_ADMIN
        redirect_to controller: 'dashboard', action: 'branch_admin'

      else
        redirect_to controller: 'dashboard', action: 'index'

      end
    else
      flash[:error] = 'Wrong username or password'
      flash[:name] = params[:username]
      redirect_to action: 'login'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to action: 'login', logged_out: 'true'
  end

  def forgot_password

    render 'forgot_password', layout: false
  end

  def forgot_password_auth
    if params[:username].present?
      found_user = User.where(username: params[:username]).first
    end

    if found_user
      reset_key = SecureRandom.hex(16)
      found_user.password_reset = reset_key
      found_user.save

      UserMailer.forgot_password(found_user, reset_key, request.base_url).deliver_now

      redirect_to action: 'login'
    else
      flash[:error] = 'Wrong username'
      redirect_to action: 'forgot_password'
    end
  end

  def reset_password

    render 'reset_password', layout: false
  end

  def reset_password_auth
    if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username], password_reset: params[:key]).first
    end

    if found_user
      found_user.password = params[:password]
      found_user.password_confirmation = params[:confirm_password]

      if found_user.save
        flash[:success] = "Your password has been reset successfully."
        redirect_to action: 'login'
      else
        flash[:error] = "Password doesn't match"
        redirect_to action: 'reset_password', :user => params[:username], :key => params[:key]
      end
    else
      flash[:error] = 'Wrong username or key'
      redirect_to action: 'reset_password', :user => params[:username], :key => params[:key]
    end
  end

  private

  def process_signin user
    session[:user_id] = user.id
  end

end
