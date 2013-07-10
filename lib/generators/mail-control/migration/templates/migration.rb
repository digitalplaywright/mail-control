# Migration responsible for creating a table with logged_emails
class CreateLoggedEmails < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :logged_emails do |t|
      t.belongs_to :actor,      :polymorphic => true
      t.belongs_to :act_object, :polymorphic => true
      t.belongs_to :act_target, :polymorphic => true

      t.string  :verb
      t.string  :description
      t.string  :options
      t.string  :bond_type

      t.time :send_after
      t.time :send_before
      t.string :state

      t.string :unsubscribe_by

      t.timestamps
    end

    add_index :logged_emails, [:verb]
    add_index :logged_emails, [:actor_id, :actor_type]
    add_index :logged_emails, [:act_object_id, :act_object_type]
    add_index :logged_emails, [:act_target_id, :act_target_type]
  end
  # Drop table
  def self.down
    drop_table :logged_emails
  end
end
