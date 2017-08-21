class RequestCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = RequestCategory.filter_by(params[:filter]).page(params[:page])
  end

  def new
    @category = RequestCategory.new
  end

  def create
    @category = RequestCategory.new category_params
    return redirect_to request_categories_path, notice: t('resources.create.success') if @category.save
    render :new
  end

  def edit
  end

  def update
    success = @category.update_attributes category_params
    return redirect_to request_categories_path, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @category.destroy
    redirect_to request_categories_path, notice: t('resources.destroy.success')
  end

  private

  def set_category
    @category = RequestCategory.find params[:id]
  end

  def category_params
    params.require(:request_category).permit :name
  end
end