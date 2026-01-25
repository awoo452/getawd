class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: %i[ show destroy ]

  # GET /documents or /documents.json
  def index
    @documents, @documents_page, @documents_total_pages =
      paginate(Document.order(created_at: :desc), per_page: 25)
  end

  def show_by_slug
    @document = Document.find_by!(slug: params[:slug])
    render :show
  end

  # GET /documents/1 or /documents/1.json
  def show
  end


  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_path, status: :see_other, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:title, :subheadings, :body, :images, :youtube_id, :metadata)
    end
end
