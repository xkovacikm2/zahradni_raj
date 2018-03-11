class EmailsController < ApplicationController
  before_action :authenticate_user!

  def index
    @emails = Email.all.page params[:page]
  end

  def show
    @email = Email.find params[:id]
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.new email_params

    if @email.save
      schedule @email
      return redirect_to emails_path, notice: t('resource.scheduled')
    end

    render :new
  end

  private
  EMAIL_LIMIT = 900

  def schedule(email)
    total_users = Customer.count
    processed = 0

    while processed < total_users
      customer_ids = Customer.all.order(id: :desc).limit(EMAIL_LIMIT).offset(processed).pluck(:id)
      EmailScheduleLog.create user_ids: customer_ids, email: email
      processed += EMAIL_LIMIT
    end
  end

  def email_params
    params.require(:email).permit :body, :subject
  end
end
