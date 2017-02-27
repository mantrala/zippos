class CreateUserZips < ActiveRecord::Migration[5.0]
  def change
    create_table :user_zips do |t|
      t.references :user
      t.references :zippo
      t.timestamps
    end
  end
end
