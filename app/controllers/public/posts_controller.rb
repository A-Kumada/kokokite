class Public::PostsController < ApplicationController
  #before_action :authenticate_user!
  before_action :guest_check, only: %i[new]

  def new
    @post = current_user.posts.build
    @post.procedures.build
  end

  def create
    @post = current_user.posts.build(post_params)
    # @tag_list = params[:post][:tag_name].split(/(\s|　)+/).reject(&:blank?)
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

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
    impressionist(@post, nil, unique: [:session_hash])
    if @post.status == "private" && @post.user != current_user
      respond_to do |format|
        format.html { redirect_to posts_path(user_id: @post.user_id), notice: 'このページにはアクセスできません' }
      end
    else
      @comment = Comment.new
      @categories = Category.all
      @tags = Tag.all
    end
    @user = @post.user
  end

  def bookmark
    @favorites = Favorite.where(user_id: current_user.id)
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
      redirect_to post_path(@post.id)
    else
      @posts = Post.all
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to '/'
  end

  def guest_check
    if current_user.email == 'guest@example.com'
      redirect_to root_path,notice: "このページを見るには会員登録が必要です。"
    end
  end

  private

  def post_params
    params.require(:post).permit(:category_id, :title, :outline, :necessaries, :image, :point, :status, tag_ids: [], procedures_attributes: [:content, :post_id, :id, :_destroy])
  end
end
