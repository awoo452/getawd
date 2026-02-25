class Document < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :metadata_must_be_hash_or_valid_json

  def category
    metadata_value = metadata_hash
    return metadata_value["category"].presence if metadata_value.is_a?(Hash)

    nil
  end

  private

  def metadata_hash
    case metadata
    when Hash
      metadata
    when String
      JSON.parse(metadata)
    else
      nil
    end
  rescue JSON::ParserError
    nil
  end

  def metadata_must_be_hash_or_valid_json
    return if metadata.blank? || metadata.is_a?(Hash)

    return if metadata.is_a?(String) && metadata_hash.is_a?(Hash)

    errors.add(:metadata, "must be valid JSON")
  end
end
