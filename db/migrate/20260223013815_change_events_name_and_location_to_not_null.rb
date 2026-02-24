class ChangeEventsNameAndLocationToNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :events, :name, false
    change_column_null :events, :location, false
  end
end
