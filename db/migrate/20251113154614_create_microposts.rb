class CreateMicroposts < ActiveRecord::Migration[8.1]
  def change
    create_table :microposts do |t|
      t.string :title
      t.string :body

      t.timestamps
    end
  end
end
