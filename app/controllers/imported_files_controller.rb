class ImportedFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @imported_files = ImportedFile.all
  end

  def new
    @import_file = ImportedFile.new
  end

  def import
    @import_files = current_user.imported_files.build(filename: params[:file].original_filename,
                                                      state: '')
    @import_files.import(params[:file], current_user) if @import_files.save
    redirect_to contacts_path, notice: 'Uploaded'
  end

  def destroy
    @imported_file = ImportedFile.find(params[:id])
    redirect_to imported_files_path, notice: 'Successfully deleted' if @imported_file.destroy
  end
end
