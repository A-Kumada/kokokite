class Public::UsersController < ApplicationController
  #before_action :authenticate_user!
  #before_action :set_current_user
  before_action :guest_check, only: %i[edit withdraw]#%i[update destroy]

  def mypage
    @user = current_user
    @posts = current_user.posts.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all
  end

  def index
    @posts = @user.posts.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to mypage_path
    else
    @user.update(is_active: "false")
      @users = User.all
      render:edit
    end
  end

  def guest_check
    if current_user == User.find(2)
      redirect_to root_path,notice: "ゲストユーザーの更新・削除はできません。"
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
    if params[:user]
      params[:user][:area] = params[:user][:area].to_i
    end
    params.require(:user).permit(:nickname, :name_kana, :area, :email, :is_active)
  end
end