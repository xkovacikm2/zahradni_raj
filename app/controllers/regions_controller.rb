class RegionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_region, only: [:edit, :update, :destroy]

  def index
    @regions = Region.includes(:country).filter_by(params[:filter]).page(params[:page])
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new region_params
    return redirect_to regions_path, notice: t('resources.create.success') if @region.save
    render :new
  end

  def edit
  end

  def update
    success = @region.update_attributes region_params
    return redirect_to regions_path, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @region.destroy
    redirect_to regions_path, notice: t('resources.destroy.success')
  end

  private

  def set_region
    @region = Region.find params[:id]
  end

  def region_params
    params.require(:region).permit :name, :country_id
  end
end