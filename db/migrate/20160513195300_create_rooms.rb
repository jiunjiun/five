class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string   :token
      t.datetime :forfeit_at

      t.timestamps
    end
  end
end
