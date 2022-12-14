class Admin::CategoriesController < ApplicationController
before_action :authenticate_admin!

def index
  @category = Category.new
  @categories = Category.all
end

def show
  @category = Category.find(params[:id])
end

def create
  @category = Category.new(category_params)
  if @category.save
    redirect_to admin_categories_path
  else
    redirect_to admin_categories_path,notice: "カテゴリ名が空白または255文字超えています"
  end
end

def edit
  @category = Category.find(params[:id])
end

def update
  @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
end

def destroy
  category = Category.find(params[:id])
  category.destroy
  redirect_to admin_categories_path
end

 private

  def category_params
    params.require(:category).permit(:category_name)
  end

end
