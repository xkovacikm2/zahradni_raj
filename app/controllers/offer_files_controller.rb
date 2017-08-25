class OfferFilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = OfferFile.find params[:id]
    @file.destroy
    redirect_to @file.customer, notice: t('resources.destroy.success')
  end
end
