class RemoveFieldFromImportedFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :imported_files, :error_msg
  end
end
