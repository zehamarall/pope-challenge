class CreateLeadInfos < ActiveRecord::Migration
  def change
    create_table :lead_infos do |t|
      t.references :lead, index: true, foreign_key: true
      t.string :mobile_phone
      t.string :personal_phone
      t.string :twitter
      t.string :facebook
      t.text :linkedin
      t.text :website

      t.timestamps null: false
    end
  end
end
