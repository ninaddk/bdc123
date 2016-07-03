class SuperadminController < ApplicationController

  def index
    redirect_to action: 'login'
  end

  def login
    if session[:superadmin] == 'yes'
      redirect_to controller: 'day_cares', action: 'index'
    else
      render 'login', layout: false
    end
  end

  def auth
    if params[:username].present? && params[:password].present? && params[:username] == AUTH['superadmin'] && params[:password] == AUTH['superadmin-password']
      session[:superadmin] = 'yes'
      redirect_to controller: 'day_cares', action: 'index'
    else
      flash[:error] = 'Wrong username or password'
      flash[:name] = params[:username]
      redirect_to action: 'login'
    end
  end

  def logout
    session[:superadmin] = 'no'
    redirect_to action: 'login'
  end

end
