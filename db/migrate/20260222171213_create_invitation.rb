class CreateInvitation < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
    add_index :invitations, [ :event_id, :user_id ], unique: true
  end
end
