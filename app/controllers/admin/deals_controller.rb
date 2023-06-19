class Admin::DealsController < Admin::BaseController
  before_action :set_deal, only: [:edit, :show, :update, :destroy, :publish, :unpublish]
  
  def new
    @deal = Deal.new
    @deal.locations.build
    @deal.deal_images.build
  end

  def edit
  end

  def show
  end

  def index
    @deals = Deal.includes(:deal_images, :locations).paginate(page: params[:page])
  end

  def create
    @deal = Deal.new(deal_params)
    @deal.user = current_user

    if @deal.save
      redirect_to admin_deals_path, notice: "new deal added successfully"
    else
      render :new
    end 
  end

  def update
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: "deal updated successfully"
    else
      render :edit
    end
  end

  def destroy
    if @deal.destroy
      redirect_to admin_deals_path, notice: "deal successfully deleted"
    else
      redirect_to admin_deals_path, alert: "published deal can't be deleted"
    end
  end

  def publish
    if @deal.update(published: true)
      redirect_to admin_deals_path, notice: 'deal published'
    else
      redirect_to admin_deals_path, alert: 'deal can not be published'
    end
  end

  def unpublish
    if @deal.update(published: false)
      redirect_to admin_deals_path, notice: 'deal unpublished'
    else
      redirect_to admin_deals_path, alert: 'can not unpublish deal'
    end
  end

  private def deal_params
    params.require(:deal).permit(:title, :description, :threshold_value, :total_availaible, :price, :start_at,
       :expire_at, :max_per_user, :category_id, :published, deal_images_attributes: [:id, :_destroy, :file],
        locations_attributes: [:id, :address, :country, :city, :state, :pincode, :_destroy])
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:id])
    redirect_to admin_deals_path, alert: 'invalid deal' if !@deal
  end
end