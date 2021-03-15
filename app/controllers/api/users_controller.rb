class Api::UsersController < ApplicationController
  before_action :selected_user, only: [:guest, :manager, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  
  def loggedInUser
    @user = current_user
    if @user
      @user = User.includes(:bookings).find(@user.id)
      render :show
    else
      render json: ""
    end
  end

  def show
    @user = User.includes(:bookings).find(params[:id])
  end

  def guest
    # ? include bookings?
  end
  
  
  def manager
    # ? include properties?
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      render :show
    else
      render json: @user.errors.full_messages, status: 401
    end
  end
  
  def update
    if @user && @user.update_attributes(user_params)
      render :show
    elsif !@user
      render json: ['Could not locate user'], status: 400
    else
      render json: @user.errors.full_messages, status: 401
    end
  end
  
  def destroy
    if @user
      @user.destroy
      render :show
    else
      render ['Could not find user']
    end
  end
  
  private
  
  def selected_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
