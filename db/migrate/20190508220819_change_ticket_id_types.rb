class ChangeTicketIdTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :user_id, :string
    remove_column :tickets, :venue_id, :string
    add_column :tickets, :user_id, :integer
    add_column :tickets, :venue_id, :integer
  end
end
