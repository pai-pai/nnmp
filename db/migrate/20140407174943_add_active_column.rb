class AddActiveColumn < ActiveRecord::Migration
  def up
    add_column :nominations, :active, :boolean, default: true
    add_column :orgs, :active, :boolean, default: true
  end

  def down
    remove_column :nominations, :active
    remove_column :orgs, :active
  end
end
