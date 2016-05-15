class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :user_token
      t.string :content
      t.boolean :is_last, defualt: false
      t.references :room, index: true, foreign_key: true

      t.timestamps
    end
  end
end
