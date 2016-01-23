class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :site
      t.string :twitter
      t.string :facebook
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps null: false
    end
  end
end
