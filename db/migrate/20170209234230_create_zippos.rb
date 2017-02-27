class CreateZippos < ActiveRecord::Migration[5.0]
  def change
    create_table :zippos do |t|
  		t.string :zipcode, null: false
  		t.string :country, null: false
  		t.string :country_abbr
  		t.string :places
      t.timestamps
    end

    add_index :zippos, :zipcode
  end
end