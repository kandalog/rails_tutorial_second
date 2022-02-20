class UserMailer < ApplicationMailer
  
  # userを含む変数を作成し、Viewで使えるようにする
  def account_activation(user)
    @user = user
    # user.emailにメール送信する, subject keyは件名にあたる
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end