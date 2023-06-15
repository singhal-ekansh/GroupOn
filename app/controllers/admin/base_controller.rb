class Admin::BaseController < ApplicationController

  before_action :authenticate
  before_action :ensure_admin

  private def ensure_admin
    if !current_user.is_admin
      redirect_to root_path, notice: 'You do not have rights to access this page'
    end
  end

end