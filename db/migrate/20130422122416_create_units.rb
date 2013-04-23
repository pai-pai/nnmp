class CreateUnits < ActiveRecord::Migration
    def up
        create_table :units do |t|
            t.string :name
            t.references :org

            t.timestamps
        end
        add_index :units, :org_id
    end

    def down
        remove_index :units, :org_id
        drop_table :units
    end
end
