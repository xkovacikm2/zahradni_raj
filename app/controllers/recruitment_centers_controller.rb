class RecruitmentCentersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_center, only: [:edit, :update, :destroy]

  def index
    @centers = RecruitmentCenter.filter_by(params[:filter]).page(params[:page])
  end

  def new
    @center = RecruitmentCenter.new
  end

  def create
    @center = RecruitmentCenter.new center_params
    return redirect_to recruitment_centers_path, notice: t('resources.create.success') if @center.save
    render :new
  end

  def edit
  end

  def update
    success = @center.update_attributes center_params
    return redirect_to recruitment_centers_path, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @center.destroy
    redirect_to recruitment_centers_path, notice: t('resources.destroy.success')
  end

  private

  def set_center
    @center = RecruitmentCenter.find params[:id]
  end

  def center_params
    params.require(:recruitment_center).permit :name
  end
end
