module Documents
  class DestroyDocument
    def self.call(document_id:)
      new(document_id: document_id).call
    end

    def initialize(document_id:)
      @document_id = document_id
    end

    def call
      document = Document.find(@document_id)
      document.destroy!
      document
    end
  end
end
