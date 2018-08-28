class SpatulaController < ApplicationController

  def index
    @spatulas = Spatula.all
  end

  def show
    @spatula = Spatula.find(params[:id])
  end

  def new
    @spatula = Spatula.new
  end

  def edit
    @spatula = Spatula.find(params[:id])
  end

  def create
    @spatula = Spatula.new(spatula_params)
    if @spatula.save
      redirect_to @spatula
    else
      render 'new'
    end
  end

  def update
    @spatula = Spatula.find(params[:id])
    if @spatula.update(spatula_params)
      redirect_to @spatula
    else
      render 'edit'
    end
  end

  def destroy
    @spatula = Spatula.find(params[:id])
    @spatula.update({deleted:true})
    redirect_to spatulas_path
  end

  private

  def spatula_params
    params.require(:spatula).permit(:color, :price)
  end

end