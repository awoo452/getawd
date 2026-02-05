module Documents
  class IndexData
    Result = Struct.new(:documents, :documents_page, :documents_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      documents, documents_page, documents_total_pages =
        @paginator.call(Document.order(created_at: :desc), per_page: 25)

      Result.new(
        documents: documents,
        documents_page: documents_page,
        documents_total_pages: documents_total_pages
      )
    end
  end
end
