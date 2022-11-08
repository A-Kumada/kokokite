class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_check, only: %i[create]

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @favorite.save
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @favorite.destroy
    redirect_to post_path(@post)
  end

  def guest_check
    if current_user == User.find(1)
      redirect_to root_path,notice: "お気に入り登録するには会員登録が必要です。"
    end
  end

end
