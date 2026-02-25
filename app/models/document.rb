class Document < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  def category
    metadata_value = metadata
    metadata_value = JSON.parse(metadata_value) if metadata_value.is_a?(String)
    return metadata_value["category"].presence if metadata_value.is_a?(Hash)

    nil
  rescue JSON::ParserError
    nil
  end
end
