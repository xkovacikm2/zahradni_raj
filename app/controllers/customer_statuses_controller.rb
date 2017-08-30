class CustomerStatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer_status, only: [:edit, :update, :destroy]

  def index
    @customer_statuses = CustomerStatus.filter_by(params[:filter]).page(params[:page])
  end

  def new
    @customer_status = CustomerStatus.new
  end

  def create
    @customer_status = CustomerStatus.new customer_status_params
    return redirect_to customer_statuses_path, notice: t('resources.create.success') if @customer_status.save
    render :new
  end

  def edit
  end

  def update
    success = @customer_status.update_attributes customer_status_params
    return redirect_to customer_statuses_path, notice: t('resources.update.success') if success
    render :edit
  end

  def destroy
    @customer_status.destroy
    redirect_to customer_statuses_path, notice: t('resources.destroy.success')
  end

  private

  def set_customer_status
    @customer_status = CustomerStatus.find params[:id]
  end

  def customer_status_params
    params.require(:customer_status).permit :name, :color
  end
end
