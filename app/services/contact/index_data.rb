module Contact
  class IndexData
    Result = Struct.new(:contact_info, keyword_init: true)

    def self.call
      new.call
    end

    def call
      path = Rails.root.join("config", "contact_info.yml")
      contact_info =
        if File.exist?(path)
          YAML.safe_load(File.read(path)) || {}
        else
          {}
        end

      Result.new(contact_info: contact_info)
    end
  end
end
