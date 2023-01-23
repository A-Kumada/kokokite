class Admin::PostsController < ApplicationController
 before_action :authenticate_admin!

  def index
    if params[:tag_ids]
      tag_ids=[]
      params[:tag_ids].each do |key, value|
        tag_ids += Tag.where(name: key).pluck(:id) if value == "1"
      end
      @posts = Post.joins(:tags).where(status: "public").where(tags:{id: tag_ids}).distinct.page(params[:page])
    elsif params[:search].present?
      @posts = Post.where(status: "public").search(params[:search]).order(created_at: :desc)
      @posts = Kaminari.paginate_array(@posts).page(params[:page])
    elsif params[:category_id].present?
      @category = Category.find(params[:category_id])
      @posts = @category.posts.where(status: "public").order(created_at: :desc)
      @posts = Kaminari.paginate_array(@posts).page(params[:page])
    else
      @posts = Post.where(status: "public").all.order(created_at: :desc).page(params[:page])
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