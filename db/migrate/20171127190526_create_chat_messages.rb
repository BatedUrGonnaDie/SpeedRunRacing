class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.belongs_to :chat_room
      t.belongs_to :user
      t.text :body
      t.timestamps
    end
  end
end
