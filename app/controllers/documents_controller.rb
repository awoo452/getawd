class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show destroy ]

  # GET /documents or /documents.json
  def index
    data = Documents::IndexData.call(paginator: method(:paginate))
    @documents = data.documents
    @documents_by_category = @documents.group_by do |document|
      document.category || "uncategorized"
    end
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
    Documents::DestroyDocument.call(document_id: @document.id)

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
end
