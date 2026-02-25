module About
  class IndexData
    Result = Struct.new(:about_sections, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(about_sections: AboutSection.ordered)
    end
  end
end
