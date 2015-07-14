require 'rails_helper'

RSpec.describe Services::Base do
  describe '#success!' do
    it 'returns a ResultSuccess' do
      result = Services::Base.new.success!
      expect(result).to be_a Services::Base::ResultSuccess
    end
  end

  describe '#error!' do
    it 'returns a ResultError' do
      result = Services::Base.new.error!("message")
      expect(result).to be_a Services::Base::ResultError
    end
  end

  describe Services::Base::ResultSuccess do
    let(:result) { Services::Base.new.success!('chocolat') }

    describe '#success?' do
      it 'should be true' do
        expect(result.success?).to be true
      end
    end

    describe '#value' do
      it 'should have service output value' do
        expect(result.value).to eq 'chocolat'
      end
    end

    describe '#message' do
      it 'has no message' do
        expect(result.message).to be_empty
      end
    end
  end

  describe Services::Base::ResultError do
    let(:result) { Services::Base.new.error!('chocolat error') }

    describe '#success?' do
      it 'should be false' do
        expect(result.success?).to be false
      end
    end

    describe '#value' do
      it 'has no output value' do
        expect(result.value).to be nil
      end
    end

    describe '#message' do
      it 'should have error message' do
        expect(result.message).to eq 'chocolat error'
      end
    end
  end
end