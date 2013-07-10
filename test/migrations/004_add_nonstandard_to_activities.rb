class AddNonstandardToActivities < ActiveRecord::Migration
  def change
    change_table :logged_emails do |t|
      t.string :nonstandard
    end
  end
end
