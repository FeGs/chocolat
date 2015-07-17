require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:api_key) { FactoryGirl.create(:api_key) }

  it 'generates a key before creation' do
    expect(api_key.value).to be_present
  end

  describe '#revoke!' do
    it 'revokes self' do
      expect(api_key.revoked).to be false
      api_key.revoke!
      expect(api_key.revoked).to be true
    end
  end

  describe '.permitted' do
    it 'fetches permitted api keys' do
      expect(ApiKey.permitted).to include(api_key)
      api_key.revoke!
      expect(ApiKey.permitted).not_to include(api_key)
    end
  end
end
