class LastLoginFixForSorcery < ActiveRecord::Migration
  def up
    add_column :users, :last_login_from_ip_address, :string
  end

  def down
    remove_column :users, :last_login_from_ip_address
  end
end
