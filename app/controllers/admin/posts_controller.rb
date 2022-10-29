class Admin::PostsController < ApplicationController
 before_action :authenticate_admin!

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
  end

end