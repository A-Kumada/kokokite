class Public::PostsController < ApplicationController
  def new
    @post = current_user.posts.build
    @post.procedures.build
  end

  def create
    @post = current_user.posts.build(post_params)

    @tag_list = params[:post][:tag_name].split(nil)
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
      @posts = Post.search(params[:search])
    elsif params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.post.order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
      @tag_lists = Tag.all
      #@items = Kaminari.paginate_array(items).page(params[:page]).per(10)

    if params[:category_id].present?
      #presentメソッドでparams[:category_id]に値が含まれているか確認 => trueの場合下記を実行
      @category = Category.find(params[:category_id])
      @posts = @category.posts
    end

    @tags = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
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
    post = Post.find(params[:id])
    post.destroy
    redirect_to '/posts'
  end


  def post_params
    params.require(:post).permit(:user_id, :category_id, :title, :outline, :necessaries, :image, :point, tags_attributes:[:tag_name], procedures_attributes: [:content, :post_id,:id, :_destroy])
  end


end
