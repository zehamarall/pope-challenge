class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :email
      t.string :name
      t.string :job_title
      t.text :bio
      t.boolean :opportunity
      t.boolean :available_for_mailing
      t.integer :conversion_sum
      t.references :company, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
      t.references :state, index: true, foreign_key: true
      t.string :tags

      t.timestamps null: false
    end
  end
end
