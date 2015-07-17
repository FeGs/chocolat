class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, id: false do |t|
      t.uuid :id, primary_key: true, index: true
      t.timestamps null: false
    end
  end
end
