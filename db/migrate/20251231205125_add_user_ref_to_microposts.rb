class AddUserRefToMicroposts < ActiveRecord::Migration[8.1]
  def change
    add_reference :microposts, :user, null: false, foreign_key: true
  end
end
