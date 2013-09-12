class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :username
      t.text :message
      t.string :action
      t.datetime :timestamp
      t.references :channel, index: true

      t.timestamps
    end
  end
end
