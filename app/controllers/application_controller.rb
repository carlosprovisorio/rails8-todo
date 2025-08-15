class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  before_action :set_current_user_from_session_or_cookie

  allow_browser versions: :modern

  private

  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to sign_in_path, alert: "Please sign in." unless user_signed_in?
  end

  def set_current_user_from_session_or_cookie
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:remember_user_id]
      @current_user = User.find_by(id: cookies.encrypted[:remember_user_id])
      session[:user_id] = @current_user.id if @current_user
    end
  end
end
