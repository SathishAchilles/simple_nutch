class CreateJobQueues < ActiveRecord::Migration[5.2]
  def up
    create_table :job_queues do |table|
      table.string :url
      table.integer :depth
      table.integer :status, default: 0
      table.integer :duplicate_reference, default: 0
      table.references :nutch_request, index: true, foreign_key: true
    end
  end

  def down
    drop_table :job_queues
  end
end
