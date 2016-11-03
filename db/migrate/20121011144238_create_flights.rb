class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :num_flight 
      t.string :date
      t.string :depart
      t.string :from
      t.string :to
      t.string :duration
      t.integer :cost
      t.integer :passenger
      t.timestamps
    end

    create_table :user_flights do |t|
      t.integer :user_id
      t.integer :flight_id
      t.timestamps
    end 


    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :user_bookings do |t|
      t.integer :booking_id
      t.integer :user_id
    end  

    create_table :bookings do |t|
      t.integer :num_booking
      t.integer :total_cost
      t.integer :flight_id
      t.timestamps
    end  
  end
end
