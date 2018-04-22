class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      user.activate
      log_in(user)
      flash[:success] = "欢迎访问Micropost！"
      redirect_to(user)
    else
      flash[:danger] = "无效的验证！"
      redirect_to(root_url)
    end
  end
end
