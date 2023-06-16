class Merchant::BaseController < ApplicationController
  before_action :authenticate
  before_action :ensure_merchant

  private def ensure_merchant
    if !current_user.merchant?
      redirect_to root_path, alert: 'Only merchant can access this section'
    end
  end
end