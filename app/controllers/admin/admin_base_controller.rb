class Admin::AdminBaseController < ApplicationController

  before_action :authenticate
  before_action :ensure_admin

  private def ensure_admin
    if !current_user.is_admin
      redirect_to root_path, alert: 'Only admin can access this section'
    end
  end

end