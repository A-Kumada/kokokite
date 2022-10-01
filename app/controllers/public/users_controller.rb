class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_current_user
  
  def show
    @user = current_user
    @posts = current_user.posts.all
  end
  
  def index
    @posts = current_user.posts.all
  end
  

  def edit
    @user = User.find(params[:id])
  end

  def update
    @cuser = User.find(params[:id])
    if @user.update(user_params)
       redirect_to users_my_page_path
    else
      @users = User.all
      render:edit
    end
  end

  def unsubscribe
    @user = User.find(current_user.id)
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_active: "false")
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :name_kana, :area, :address, :email)
  end
end