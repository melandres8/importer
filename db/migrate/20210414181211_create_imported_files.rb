class CreateImportedFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :imported_files do |t|
      t.string :filename
      t.string :error_msg
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
