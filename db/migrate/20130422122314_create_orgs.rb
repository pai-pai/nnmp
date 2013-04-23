class CreateOrgs < ActiveRecord::Migration
    def up
        create_table :orgs do |t|
            t.string :name
            t.references :area

            t.timestamps
        end
        add_index :orgs, :area_id
    end

    def down
        remove_index :orgs, :area_id
        drop_table :orgs
    end
end
