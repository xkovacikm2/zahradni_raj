class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:edit, :update, :destroy]

  def index
    @customers = Customer.includes(:recruitment_center, :region, :requests).filter_by(params[:filter]).page params[:page]
  end

  def show
    @customer = Customer.includes(:recruitment_center, :country, :region, requests: :offer).find params[:id]
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new customer_params
    return redirect_to @customer, notice: t('resources.create.success') if @customer.save
    render :new
  end

  def edit
  end

  def update
    return redirect_to @customer, notice: t('resources.update.success') if @customer.update customer_params
    render :edit
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: t('resources.destroy.success')
  end

  def write_emails
  end

  def send_emails
    customers = Customer.all

    customers.each do |customer|
      CustomerMailer.mass_emails(customer.email, params[:content], params[:subject]).deliver_later
    end

    redirect_to customers_path, notice: t('resources.email.delivered')
  end

  private

  def set_customer
    @customer = Customer.find params[:id]
  end

  def customer_params
    params.require(:customer).permit :name, :surname, :company, :ico, :dic, :address, :email, :phone, :note, :country_id,
                                     :recruitment_center_id, :region_id, :customer_status_id,
                                     requests_attributes: [:_destroy, :id, :date, request_categories: []]
  end
end
