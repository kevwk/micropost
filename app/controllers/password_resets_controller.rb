class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_resets][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "邮件已发送，请检查邮箱！"
      redirect_to root_url
    else
      flash[:danger] = "邮箱地址无效！"
      render "new"
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "密码不能为空！")
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "密码重置成功！"
      redirect_to @user
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "密码重置已过期！"
      redirect_to new_password_reset_url
    end
  end
end
