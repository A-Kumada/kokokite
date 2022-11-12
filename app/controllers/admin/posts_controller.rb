class Admin::PostsController < ApplicationController
 before_action :authenticate_admin!

  def index
    if params[:tag_ids]
      @posts = []
      params[:tag_ids].each do |key, value|
        @posts += Tag.find_by(name: key).posts.where(status: "public") if value == "1"
      end
    elsif params[:search].present?
      @posts = Post.where(status: "public").search(params[:search]).sort {|a,b| b.favorites.size <=> a.favorites.size}
    elsif params[:category_id].present?
      @category = Category.find(params[:category_id])
      @posts = @category.posts.where(status: "public").sort {|a,b| b.favorites.size <=> a.favorites.size}
    else
      @posts = Post.where(status: "public").all.order(created_at: :desc)
    end
    @tags = Tag.all
    @categories = Category.all
  end


  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
    @categories = Category.all
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