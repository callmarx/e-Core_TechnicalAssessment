class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    # References: https://thoughtbot.com/blog/enum-validations-and-database-constraints-in-rails-7-1
    create_enum :abilities, ["Developer", "Product Owner", "Tester"]

    create_table :roles do |t|
      t.uuid :team_id, null: false
      t.uuid :user_id, null: false
      t.enum :ability, enum_type: "abilities", null: false, default: "Developer"

      t.timestamps
    end

    add_index :roles, [:team_id, :user_id, :ability], unique: true
  end
end
