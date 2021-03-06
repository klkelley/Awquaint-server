class UsersController < ApplicationController
  def index
  end

  def create
    @user = User.create(user_params)
    @user.interest ||= "No interest provided"
    if @user.save
       render json: {id: @user.id, name: @user.name, interest: @user.interest}, status: :ok
    else
       render json: {status: "Error", message: "#{@user.errors.full_messages}"}, status: 400
    end
  end

  def search
    user = User.find(params[:id].to_i)
    user.longitude = params[:longitude].to_f
    user.latitude = params[:latitude].to_f
    user.save

    render json: user.nearby.map { |user| {id: (user.id).to_s, interest: user.interest} }
  end

  def add_image
    @user = User.find(params[:id].to_i)
    @user.image = params[:image]
    @user.save

    render json: {id: @user.id, name: @user.name, interest: @user.interest, image: @user.image.url }, status: :ok
  end

  def edit_interest
    @user = User.find(params[:id].to_i)
    @user.interest = params[:interest]
    @user.save

    render json: {id: @user.id, name: @user.name, interest: @user.interest, image: @user.image.url }, status: :ok
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :interest, :image)
  end
end
