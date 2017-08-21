class CountriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_country, only: [:edit, :update, :destroy]

  def index
    @countries = Country.filter_by(params[:filter]).page(params[:page])
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new country_params
    return redirect_to countries_path, notice: t('resources.create.success') if @country.save
    render :new
  end

  def edit
  end

  def update
    success = @country.update_attributes country_params
    return redirect_to countries_path, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @country.destroy
    redirect_to countries_path, notice: t('resources.destroy.success')
  end

  private

  def set_country
    @country = Country.find params[:id]
  end

  def country_params
    params.require(:country).permit :name
  end
end