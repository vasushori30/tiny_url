class CreateVisitors < ActiveRecord::Migration[5.1]
  def change
    create_table :visitors do |t|
      t.integer :short_url_id
      t.string :ip_address

      t.timestamps
    end
  end
end
