class Referral < ApplicationRecord

  # validate :can_not_back_refer
  # validate :only_two_referal_allowed
  # validate :already_accepted_deal, on: :update ,if: ->{ invitation_accepted_at && !invitation_accepted_at_was }

  validates :referee_email, presence: true

  belongs_to :user
  belongs_to :deal

  after_create_commit :send_referral_mail

  # def can_not_back_refer
  #   refered_by = Referal.where.not(redeemed_at: nil).find_by(deal: deal, referee: referer)
  #   errors.add('can not refer to someone who refered you') if refered_by == referee
  # end

  # def only_two_referal_allowed
  #   refered_count = Referal.where(deal: deal, referer: referer).count
  #   errors.add('deal can be refered only two times') if refered_count >= 2
  # end

  # def already_accepted_deal
  #   errors.add('already accepted invitaion for this deal') if Referal.where.not(invitation_accepted_at: nil).find_by(deal: deal, referee_id: referee_id)
  # end

  private def generate_token
    @token = signed_id(purpose: 'referal')
  end

  private def send_referral_mail
    generate_token
    UserMailer.send_referral(self, @token).deliver_later
  end
end