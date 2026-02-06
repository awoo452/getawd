module Documents
  class IndexData
    Result = Struct.new(:documents, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      Result.new(
        documents: Document.order(created_at: :desc)
      )
    end
  end
end
