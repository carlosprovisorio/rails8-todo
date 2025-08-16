class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      if params[:remember_me] == "1"
        cookies.encrypted[:remember_user_id] = { value: user.id, expires: 30.days }
      else
        cookies.delete(:remember_user_id)
      end
      redirect_to root_path, notice: "Signed in."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    cookies.delete(:remember_user_id)
    redirect_to sign_in_path, notice: "Signed out."
  end
end
