class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :image_url
      t.text :description
      t.string :location
      t.date :start_date
      t.date :end_date
      t.string :start_time
      t.string :end_time
      t.integer :total_tickets
      t.integer :remaining_tickets
      t.integer :amount

      t.timestamps
    end
  end
end
