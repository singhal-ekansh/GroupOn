class Admin::DealsController < ApplicationController

  def new
    @deal = Deal.new
    @deal.locations.build
    @deal.images.build
  end

  def edit
    @deal = Deal.find(params[:id])
  end

  def create
    debugger
    @user = User.find(session[:user_id])

    @deal = @user.deals.build(deal_params.except(:images_attachments_attributes))
    
    save_images
    
    if @deal.save
      redirect_to edit_admin_deal_path(@deal), notice: "deal added successfully"
    else
      render :new
    end
  

  end

  private def deal_params
    params.require(:deal).permit(:title, :description, :threshold_value, :total_availaible, :price, :start_at,
       :expire_at, :max_per_user, :category_id, :published, images_attachments_attributes: [:id, :_destroy, :images],
        locations_attributes: Location.attribute_names.map(&:to_sym).push(:_destroy))
  end

  private def save_images
    params[:deal][:images_attachments_attributes]&.each do |k,v|
      next unless v[:images].present?
      @deal.images.attach(v[:images]) if v[:_destroy].eql?('false')
    end
  end
end