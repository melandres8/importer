class AddStateToImportedFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :imported_files, :state, :string
  end
end
