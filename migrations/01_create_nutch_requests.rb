class CreateNutchRequests < ActiveRecord::Migration[5.2]
  def up
    create_table :nutch_requests do |table|
      table.column :url, :string
      table.column :status, :integer, default: 0
    end
  end

  def down
    drop_table :nutch_requests
  end
end
