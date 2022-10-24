class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = current_user.posts.build
    @post.procedures.build
  end

  def create
    @post = current_user.posts.build(post_params)
    # byebug
    @tag_list = params[:post][:tag_name].split(/(\s|　)+/).reject(&:blank?)
    @post.image.attach(params[:post][:image])
    @post.user_id = current_user.id
    if @post.save
      @post.save_posts(@tag_list)
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def index
    if params[:search].present?
      @posts = Post.where(status: "public").search(params[:search]).sort {|a,b| b.favorites.size <=> a.favorites.size}
    elsif params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.where(status: "public").order(created_at: :desc)
    elsif params[:category_id].present?
      @category = Category.find(params[:category_id])
      @posts = @category.posts.where(status: "public").sort {|a,b| b.favorites.size <=> a.favorites.size}
    else
      @user = User.find(params[:user_id])
      @posts = @user.posts.where(status: "public").all.order(created_at: :desc)
    end
      @tag_lists = Tag.all

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
      @tag_lists = Tag.all
    end

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
      flash[:success] = 'You have updated book successfully.'
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

  private

  def post_params
    params.require(:post).permit(:user_id, :category_id, :title, :outline, :necessaries, :image, :point, :status, :image, tags_attributes:[:tag_name], procedures_attributes: [:content, :post_id,:id, :_destroy])
  end

  def article_params
    params.require(:article).permit(:body, tag_ids: [])
  end


end
