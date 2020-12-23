class CreateSiteMaps < ActiveRecord::Migration[5.2]
  def up
    create_table :site_maps do |table|
      table.references :nutch_request, index: true, foreign_key: true
      table.string :url
      table.string :query_params
      table.integer :reference_count, default: 1
    end
  end

  def down
    drop_table :site_maps
  end
end
