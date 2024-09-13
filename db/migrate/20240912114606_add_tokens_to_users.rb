class AddTokensToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :tokens, :text
    add_column :users, :allow_password_change, :boolean, default: false
    User.reset_column_information
    User.find_each do |user|
      user.uid = user.email
      user.provider = 'email'
      user.save!
    end
  end
end
