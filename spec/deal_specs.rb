require 'rails_helper'

RSpec.describe Deal, type: :model do
  let!(:unpublished_deal) { build(:deal, :admin) }
  let!(:published_deal) { build(:deal, :admin, :published) }

  context 'published false' do
    it 'unpublished deal can be saved as draft' do 
      expect(unpublished_deal).to be_valid 
    end

    it 'title cannot be blank' do
      unpublished_deal.title = nil
      expect(unpublished_deal).to_not be_valid 
    end

    it 'merchant must exist' do 
      unpublished_deal.merchant = nil
      expect(unpublished_deal).to_not be_valid 
    end

    it 'category must exist' do 
      unpublished_deal.category = nil
      expect(unpublished_deal).to_not be_valid 
    end
  end


  context 'published true' do
    it 'valid deal with image and location' do 
      expect(published_deal).to be_valid 
    end

    it 'without image' do 
      published_deal.images = []
      expect(published_deal).to_not be_valid 
    end

    it 'without location' do 
      published_deal.locations = []
      expect(published_deal).to_not be_valid 
    end

    it 'description must exists' do 
      published_deal.description = nil
      expect(published_deal).to_not be_valid 
    end

    it 'start_at must exists' do 
      published_deal.start_at = nil
      expect(published_deal).to_not be_valid 
    end

    it 'expire_at must exists' do 
      published_deal.expire_at = nil
      expect(published_deal).to_not be_valid 
    end

    it 'threshold_value must exists' do 
      published_deal.threshold_value = nil
      expect(published_deal).to_not be_valid 
    end

    it 'total_availaible must exists' do 
      published_deal.total_availaible = nil
      expect(published_deal).to_not be_valid 
    end
    
    it 'expire_at greater or equal to start_at' do 
      published_deal.expire_at = published_deal.start_at - 1.day
      expect(published_deal).to_not be_valid 
    end

    it 'threshold_value less or equal to total_availaible' do 
      published_deal.threshold_value = published_deal.total_availaible + 1
      expect(published_deal).to_not be_valid 
    end
  end

end