class Admin::DealsController < ApplicationController
  before_action :authenticate
  before_action :ensure_admin
  
  def new
    @deal = Deal.new
    @deal.locations.build
    # @deal.deal_images.build
  end

  def edit
    @deal = Deal.find_by(id: params[:id])
  end

  def show
    @deal = Deal.find_by(id: params[:id])
  end

  def index
    @deals = Deal.includes(:deal_images).where(user_id: current_user.id)
  end

  def create
    @deal = current_user.deals.build(deal_params)
    
    if @deal.save
      redirect_to admin_deals_path, notice: "new deal added successfully"
    else
      render :new
    end
  
  end

  def update
    @deal = Deal.find_by(id: params[:id])
  
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: "deal updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @deal = Deal.find_by(id: params[:id])

    if @deal.destroy
      redirect_to admin_deals_path, notice: "deal successfully deleted"
    else
      flash.now[:alert] = "deal can't be deleted"
      render :index
    end
  end

  private def deal_params
    params.require(:deal).permit(:title, :description, :threshold_value, :total_availaible, :price, :start_at,
       :expire_at, :max_per_user, :category_id, :published, deal_images_attributes: [:id, :_destroy, :file],
        locations_attributes: [:id, :address, :city, :state, :pincode, :_destroy])
  end

end