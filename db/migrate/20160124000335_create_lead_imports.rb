class CreateLeadImports < ActiveRecord::Migration
  def change
    create_table :lead_imports do |t|
      t.string :file
      t.integer :leads_imported
      t.integer :leads_updated
      t.string :process_status

      t.timestamps null: false
    end
  end
end
