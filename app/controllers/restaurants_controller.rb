class RestaurantsController < ApplicationController
  
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :image)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = "#{@restaurant.name} can only be edited by creator"
      redirect_to '/restaurants'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user === current_user
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = "#{@restaurant.name} can only be edited by creator"
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user === current_user
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:notice] = "#{@restaurant.name} can only be deleted by creator"
    end
    redirect_to '/restaurants'
  end

end
