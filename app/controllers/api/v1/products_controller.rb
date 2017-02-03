class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json
	
	def show
    respond_with Product.find(params[:id])
  end

  def index
    respond_with Product.all  
  end
  
end
