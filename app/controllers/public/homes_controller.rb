class Public::HomesController < ApplicationController
  def top
    @categories = Category.all
  end

  def about
  end
  
  def bookmark
    @favorites = Favorite.where(user_id: current_user.id)
  end
  
end
