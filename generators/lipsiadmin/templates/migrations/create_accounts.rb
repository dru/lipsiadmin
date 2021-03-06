class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.string      :email, :remember_token
      t.string      :crypted_password, :salt, :activation_code, :limit => 40
      t.datetime    :activated_at, :remember_token_expires_at
      t.string      :role
      t.text        :modules
      t.timestamps
    end

    # I'll create the first account
    Account.create({:email => "info@lipsiasoft.com", 
                   :password => "admin", 
                   :password_confirmation => "admin", :role => "administrator", :modules => [:accounts] })
  end

  def self.down
    drop_table "accounts"
  end
end