class PasswordResetsController < ApplicationController
  before_action :load_user_from_token, only: [ :edit, :update ]

  def new; end

  def create
    if (user = User.find_by(email: params[:email].to_s.downcase.strip))
      token = user.signed_id(purpose: :password_reset, expires_in: 30.minutes)
      PasswordMailer.with(user:, token:).reset.deliver_later
    end
    redirect_to sign_in_path, notice: "If your email exists in our system, you'll receive a reset link shortly."
  end

  def edit
    # @user is loaded by before_action
  end

  def update
    if @user.update(password_params)
      redirect_to sign_in_path, notice: "Your password has been reset. Please sign in."
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_reset_path, alert: "Your reset link has expired. Please request a new one."
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user_from_token
    token = params[:token].presence ||
            params.dig(:user, :token).presence ||
            params.dig(:password_reset, :token).presence

    @user = User.find_signed!(token, purpose: :password_reset)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_reset_path, alert: "Your reset link has expired. Please request a new one."
  end
end
