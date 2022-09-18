class Public::PostsController < ApplicationController
  def new
    @post = current_user.posts.build
    @post.procedures.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def index
    @user = current_user
    @posts = Post.all
    if params[:category_id].present?
      #presentメソッドでparams[:category_id]に値が含まれているか確認 => trueの場合下記を実行
      @category = Category.find(params[:category_id])
      @posts = @category.posts
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])

    unless
      @post.user == current_user
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
    @post = Post.find(params[:id])
    post.destroy
    redirect_to '/posts'
  end


  def post_params
    params.require(:post).permit(:user_id, :category_id, :title, :outline, :necessaries, :image, :point, procedures_attributes: [:content, :post_id,:id, :_destroy])
  end

end
