class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: [:edit, :update, :destroy]

  def new
    @request = Request.new customer_id: params[:id]
  end

  def create
    @request = Request.new request_params
    return redirect_to @request.customer, notice: t('resources.create.success') if @request.save
    render :new
  end

  def edit
  end

  def update
    success = @request.update_attributes request_params
    return redirect_to @request.customer, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @request.destroy
    redirect_to @request.customer, notice: t('resources.destroy.success')
  end

  private

  def set_request
    @request = Request.find params[:id]
  end

  def request_params
    params.require(:request).permit :date, :customer_id, request_categories: []
  end
end