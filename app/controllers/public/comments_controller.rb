class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_check, only: %i[create]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post),notice: "コメントが空白または255文字超えています"
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  def guest_check
    if current_user == User.find(2)
      redirect_to root_path,notice: "コメントするには会員登録が必要です。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
