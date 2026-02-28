module Projects
  class SectionCopy
    def self.call
      new.call
    end

    def call
      path = Rails.root.join("config", "project_sections.yml")
      return {} unless File.exist?(path)

      data = YAML.safe_load(File.read(path)) || {}
      data.is_a?(Hash) ? data.with_indifferent_access : {}
    end
  end
end
