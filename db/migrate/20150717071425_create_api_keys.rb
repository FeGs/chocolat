class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.uuid :project_id
      t.string :value
      t.integer :scope
      t.boolean :revoked, default: false
      t.timestamps null: false
    end
  end
end
