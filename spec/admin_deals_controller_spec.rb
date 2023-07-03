require 'rails_helper'

RSpec.describe Admin::DealsController, type: :request do
  
  describe 'GET index' do
    context 'when user is an admin' do
      let(:user) { create(:user, :admin) }
      before do
        post sessions_path, params: {email: user.email, password: user.password }
      end

      before do
        get admin_deals_path
      end

      it 'can view all deals' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when user is not an admin' do

      let(:user) { create(:user) }
      before do
        post sessions_path, params: {email: user.email, password: user.password}
      end

      before do
        get admin_deals_path
      end

      it 'can view all deals' do
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('You do not have rights to access this page')
      end

    end
  end

  describe 'GET/admin/deals/new' do
    let(:user) { create(:user, :admin) }
    before do
      post sessions_path, params: {email: user.email, password: user.password}
    end

    before do 
      get new_admin_deal_path
    end

    it 'renders new' do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end

  end

  describe 'POST/admin/deals/create' do

    let(:user) { create(:user, :admin) }
    let(:deal_params) { { deal: attributes_for(:deal) }  }

    before do
      post sessions_path, params: { email: user.email, password: user.password }
    end

    before do 
      expect {
        post admin_deals_path, params: deal_params
      }.to change(Deal, :count).by(1)
      @deal = Deal.last
    end


    it 'admin can create a deal' do
      expect(response).to have_http_status(302)
      expect(@deal.title).to eq(deal_params[:deal][:title])
      expect(response).to redirect_to(admin_deals_path)
      expect(flash[:notice]).to eq('new deal added successfully')
    end
  end

  describe 'GET/admin/deals/edit' do

    let(:user) { create(:user, :admin) }
    let(:deal) { create(:deal, :admin)}
    before do
      post sessions_path, params: {email: user.email, password: user.password}
    end

    before do 
      get edit_admin_deal_path(deal.id)
    end

    it 'renders edit ' do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET/admin/deals/show' do

    let(:user) { create(:user, :admin) }
    let(:deal) { create(:deal, :admin)}
    before do
      post sessions_path, params: {email: user.email, password: user.password}
    end

    before do 
      get admin_deal_path(deal)
    end

    it 'renders edit ' do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'PATCH/update' do

    let(:user) { create(:user, :admin) }
    let(:deal) { create(:deal, :admin) }
    let(:deal_params) { { deal: attributes_for(:deal) }  }

    before do
      post sessions_path, params: { email: user.email, password: user.password }
    end

    before do 
      patch admin_deal_path(deal), params: deal_params
    end


    it 'admin can edit a deal' do
      expect(response).to have_http_status(302)
      expect(deal.reload.title).to eq(deal_params[:deal][:title])
      expect(response).to redirect_to(admin_deal_path(deal))
      expect(flash[:notice]).to eq('deal updated successfully')
    end
  end

  describe 'Destroy Deal' do

    let(:user) { create(:user, :admin) }
    before do
      post sessions_path, params: {email: user.email, password: user.password }
    end

    context 'when deal published' do 
      let!(:published_deal) { create(:deal, :published, :admin) }

      before do 
        expect {
          delete admin_deal_path(published_deal)
        }.to change(Deal, :count).by(0)
      end
      it 'can not destroy' do 
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("published deal can't be deleted")
      end
    end

    context 'when deal not published' do 
      let!(:unpublished_deal) { create(:deal, :admin) }

      before do 
        expect {
          delete admin_deal_path(unpublished_deal)
        }.to change(Deal, :count).by(-1)
      end

      it 'can destroy' do
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq("deal successfully deleted")
      end
    end
  end

  describe 'Publish a deal' do 

    let(:user) { create(:user, :admin) }
    before do
      post sessions_path, params: {email: user.email, password: user.password }
    end

    context 'when deal is valid' do

      let!(:valid_deal) { create(:deal, :valid, :admin) }
    
      before do
        patch publish_admin_deal_path(valid_deal)
      end
    
      it 'can be published' do
        expect(valid_deal.reload.published).to eq(true)
        expect(flash[:notice]).to eq('deal published')
      end 
    end

    context 'when deal is invalid' do
      let!(:invalid_deal) { create(:deal, :admin) }
     
      before do
        patch publish_admin_deal_path(invalid_deal)
      end

      it 'can not be published' do
        expect(invalid_deal.reload.published).to eq(false)
        expect(flash[:alert]).to eq('deal can not be published')
      end
    end

  end

  describe 'Unpublish a deal' do 

    let(:user) { create(:user, :admin) }
    before do
      post sessions_path, params: {email: user.email, password: user.password }
    end

    context 'when deal is published' do

      let!(:published_deal) { create(:deal, :published, :admin) }
    
      before do
        patch unpublish_admin_deal_path(published_deal)
      end
    
      it 'can be unpublished' do
        expect(published_deal.reload.published).to eq(false)
        expect(flash[:notice]).to eq('deal unpublished')
      end 
    end

    context 'when deal is invalid' do
      let!(:published_live_deal) { create(:deal,:published, :live, :admin) }
     
      before do
        patch unpublish_admin_deal_path(published_live_deal)
      end

      it 'can not be unpublished' do
        expect(published_live_deal.reload.published).to eq(true)
        expect(flash[:alert]).to eq('can not unpublish deal')
      end
    end

  end

end