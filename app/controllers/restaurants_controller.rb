class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show]
  def index
    if params[:query].present?
      @restaurants = Restaurant.where('LOWER(name) LIKE ?', "%#{params[:query]}%")
    else
      @restaurants = Restaurant.all
    end
  end

  def show
    @restaurant = Restaurant.includes(:reviews).find(params[:id])
    @review = @restaurant.reviews.build
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to @restaurant, notice: "Restaurant was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :category, :address, :phone_number)
  end
end
