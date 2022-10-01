class Admin::UsersController < ApplicationController
 #before_action :authenticate_admin!
 
def index
  @users = User.all.page(params[:page])
end

def show
  @user = User.find(params[:id])
end
 
def edit
  @user = User.find(params[:id])
end
 
def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to admin_user_path(@user)
  else
    @users = User.all
    render:edit
  end
end

private

  def user_params
    if params[:user]
      params[:user][:area] = params[:user][:area].to_i
    end
    params.require(:user).permit(:nickname, :name_kana, :area, :email, :is_active)
  end
  

end
