require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.create(:project) }

  it 'creates with api keys (read key, write key, master key)' do
    expect(project.read_key).to be_present
    expect(project.write_key).to be_present
    expect(project.master_key).to be_present
  end

  describe '#{scope}_key' do
    it 'should be valid' do
      expect(project.read_key).to be_present
      project.read_key.revoke!
      expect(project.read_key).to be_nil
    end
  end
end
