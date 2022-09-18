class Admin::CategoriesController < ApplicationController

def index
  @category = Category.new
  @categories = Category.all
end

def show
  @category = Category.find(params[:id])
end

def create
  @category = Category.new(category_params)
  @category.save
  redirect_to admin_categories_path
end

def edit
  @category = Category.find(params[:id])
end

def update
  @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit_admin
    end
end

 private

  def category_params
    params.require(:category).permit(:category_name)
  end

end
