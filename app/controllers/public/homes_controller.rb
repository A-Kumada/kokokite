class Public::HomesController < ApplicationController
  def top
    @categories = Category.all
  end

  def about
  end

end
