class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: :destroy

  def create
    @offer = Offer.new offer_params
    redirect_to @offer.customer, notice: t('resources.create.success') if @offer.save
    render :new
  end

  def new
    @offer = Offer.new request_id: params[:id]
  end

  def destroy
    @offer.destroy
    redirect_to @offer.customer, notice: t('resources.destroy.success')
  end

  private

  def set_offer
    @offer = Offer.find params[:id]
  end

  def offer_params
    params.require(:offer).permit :date, :request_id, offer_file_attributes: [:_destroy, :id, :stored_filename]
  end
end
