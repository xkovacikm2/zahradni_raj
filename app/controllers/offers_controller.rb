class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: [:destroy, :edit, :update]

  def create
    @offer = Offer.new offer_params
    return redirect_to @offer.customer, notice: t('resources.create.success') if @offer.save
    render :new
  end

  def new
    @offer = Offer.new request_id: params[:id]
  end

  def update
    success = @offer.update_attributes offer_params
    return redirect_to @offer.customer, notice: t('resources.update.success') if success
    render :edit
  end

  def edit
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
    params.require(:offer).permit :date, :internal_id, :request_id, :contact_date, offer_files_attributes: [:_destroy, :id, :stored_filename]
  end
end
