class ShippingLocationController < ApplicationController

  def index
    @shipping_locations = ShippingLocation.all
  end

  def show
    @shipping_location = ShippingLocation.find(params[:id])
  end

  def new
    @shipping_location = ShippingLocation.new
  end

  def edit
    @shipping_location = ShippingLocation.find(params[:id])
  end

  def create
    @shipping_location = ShippingLocation.new(shipping_location_params)
    if @shipping_location.save
      redirect_to @shipping_location
    else
      render 'new'
    end
  end

  def update
    @shipping_location = ShippingLocation.find(params[:id])
    if @shipping_location.update(shipping_location_params)
      redirect_to @shipping_location
    else
      render 'edit'
    end
  end

  def destroy
    @shipping_location = ShippingLocation.find(params[:id])
    @shipping_location.update({deleted:true})
    redirect_to shipping_locations_path
  end

  private

  def shipping_location_params
    params.require(:shipping_location).permit(:name, :zip_code)
  end

end
