class ApiKey < ActiveRecord::Base
  SCOPES = [:read_key, :write_key, :master_key]

  include ActiveUUID::UUID
  before_create :generate_key!

  belongs_to :project

  enum scope: SCOPES
  scope :permitted, -> { where(revoked: false) }
  validates :scope, presence: true

  def revoke!
    update_attributes! revoked: true
  end

private
  def generate_key!
    self[:value] = create_uuid
  end
end
