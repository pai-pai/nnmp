class CreateCandidates < ActiveRecord::Migration
    def up
        create_table :candidates do |t|
            t.string :fam_name
            t.string :first_name
            t.string :sec_name
            t.references :nomination
            t.references :org
            t.references :unit
            t.string :depart
            t.string :ward

            t.timestamps
        end

        add_index :candidates, :nomination_id
        add_index :candidates, :org_id
        add_index :candidates, :unit_id
    end

    def down
        remove_index :candidates, :nomination_id
        remove_index :candidates, :org_id
        remove_index :candidates, :unit_id
        drop_table :candidates
    end
end
