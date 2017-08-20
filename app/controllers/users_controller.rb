class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @users = User.filter_by(params[:filter]).page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    success = user_params[:password].empty? ? @user.update_without_password(user_params) : @user.update(user_params)

    return redirect_to @user, notice: t('resources.update.success') if success
    render :edit
  end

  def new
    @user = User.new
  end

  def create
    user_data = user_params

    if user_data[:password].empty?
      user_data.delete :password
      user_data.delete :password_confirmation
    end

    @user = User.new(user_data)

    return redirect_to @user, notice: t('resources.created_at') if @user.save
    render :new
  end

  private

  def set_user
    @user = User.find params[:id]
  end
  
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :current_password
  end
end