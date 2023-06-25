class ReferralController < ApplicationController

  before_action :set_referral, only: :update

  def new
  end

  def create
    
  end

  def accept_invite
    if referral.update(invitation_accepted_at: Time.now)
      redirect_to deal_path(referral.deal), notice: 'deal invitation accepted'
    else
      redirect_to root_path, alert: 'already accepted'
    end
  end

  def set_referral
    referral = Referral.find_signed!(params[:token])
  end
end