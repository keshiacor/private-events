class AddAttendanceRefs < ActiveRecord::Migration[8.1]
  def change
    add_reference :attendances, :attendee, null: false, foreign_key: { to_table: :users }, index: true
    add_reference :attendances, :attended_event, null: false, foreign_key: { to_table: :events }, index: true
    add_index :attendances, [ :attendee_id, :attended_event_id ], unique: true
  end
end
