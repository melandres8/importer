class CreateInvalidContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :invalid_contacts do |t|
      t.string :name
      t.string :birthdate
      t.string :phone
      t.string :address
      t.string :credit_card
      t.string :franchise
      t.string :four_digits
      t.string :error_msg
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
