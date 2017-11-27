class CreateChatRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_rooms do |t|
      t.belongs_to :race
      t.boolean :locked
      t.timestamps
    end
  end
end
