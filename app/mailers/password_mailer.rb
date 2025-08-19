class PasswordMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def reset
    @user = params[:user]
    @token = params[:token]
    mail to: @user.email, subject: "Reset your password"
  end
end
