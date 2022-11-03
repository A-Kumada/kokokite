class Admin::PostsController < ApplicationController
 before_action :authenticate_admin!

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
    unless
      @post.user == current_user || admin_signed_in?
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = '更新しました'
      redirect_to admin_post_path(@post.id)
    else
      @posts = Post.all
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_top_path
  end

  private

  def post_params
    params.require(:post).permit(:category_id, :title, :outline, :necessaries, :image, :point, :status, tag_ids: [], procedures_attributes: [:content, :post_id, :id, :_destroy])
  end

end