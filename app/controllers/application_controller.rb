class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def allow_if_user_logged_in
    if is_user_logged_in
      redirect_to controller: 'admin', action: 'login'
      return false

    else
      user = User.where(id: session[:user_id]).first
      @user_id = user.id
      @user_name = user.name
      @user_role = user.user_role.role_id
      @day_care_id = user.user_role.day_care_id
      @day_care_center_id = user.user_role.day_care_center_id

      if user.user_role.day_care.present?
        @day_care_name = user.user_role.day_care.name
      else
        @day_care_name = ''
      end

      if user.user_role.day_care_center.present?
        @day_care_center_name = user.user_role.day_care_center.name
      else
        @day_care_center_name = ''
      end
      return true
    end
  end

  def is_user_logged_in
    session[:user_id].blank?
  end

  def allow_if_super_admin_logged_in
    if (session[:superadmin].blank? || session[:superadmin] != 'yes')
      @user_role = nil
      redirect_to controller: 'superadmin', action: 'login'
      return false
    end
    @user_name = 'Super Admin'
    @user_role = USER_ROLE_SUPER_ADMIN
    return true
  end

  def allow_if_admin_or_super_admin_logged_in
    if session[:superadmin] == 'yes'
      @user_id = -1
      @user_name = 'Super Admin'
      @user_role = USER_ROLE_SUPER_ADMIN
      @day_care_id = -1
      @day_care_center_id = -1
      @day_care_name = ''
      @day_care_center_name = ''

    elsif !is_user_logged_in
      user = User.where(id: session[:user_id]).first
      @user_id = user.id
      @user_name = user.name
      @user_role = user.user_role.role_id
      @day_care_id = user.user_role.day_care_id
      @day_care_center_id = -1

      if user.user_role.day_care.present?
        @day_care_name = user.user_role.day_care.name
      else
        @day_care_name = ''
      end

      if user.user_role.day_care_center.present?
        @day_care_center_name = user.user_role.day_care_center.name
      else
        @day_care_center_name = ''
      end
    else

      redirect_to controller: 'admin', action: 'login'
      return false
    end
  end

  def is_admin_user
    return @user_role == USER_ROLE_ADMIN
  end

  def is_branch_admin_user
    return @user_role == USER_ROLE_BRANCH_ADMIN
  end

  def get_param name, default_value
    return (params[name].present? ? params[name] : default_value)
  end

  def render_result_json object
    response = {status: 'success', contents: object}
    render json: response
  end

  def render_success_json object
    response = {status: 'success', message: object}
    render json: response
  end

  def render_error_json message
    response = {status: 'error', message: message}
    render json: response
  end

  def has_sufficient_params(params_list)
    params_list.each do |param|
      unless params[param].present?
        render_error_json "#{param} can't be blank".camelize
        return false
      end
    end
    return true
  end

  def check_in_enum_if_exists enum, id
    if !params[id].present? || enum.is_valid_id(params[id].to_i)
      return true
    else
      render_error_json "Invalid value for #{enum.name}"
      return false
    end
  end

end
