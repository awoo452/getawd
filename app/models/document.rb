class Document < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :metadata_must_be_hash_or_valid_json
  validate :document_json_fields_must_be_arrays

  def category
    metadata_map["category"].presence
  end

  def public_document?
    metadata_value = metadata_map
    metadata_value["public"] == true || metadata_value["public"] == "true"
  end

  def metadata_map
    parse_json_hash(metadata) || {}
  end

  def subheadings_list
    parse_json_array(subheadings) || []
  end

  def body_list
    parse_json_array(body) || []
  end

  def images_list
    parse_json_array(images) || []
  end

  def youtube_ids
    parse_json_array(youtube_id) || []
  end

  private

  def parse_json_hash(value)
    case value
    when Hash
      value
    when String
      JSON.parse(value)
    else
      nil
    end
  rescue JSON::ParserError
    nil
  end

  def parse_json_array(value)
    case value
    when Array
      value
    when String
      parsed = JSON.parse(value)
      parsed.is_a?(Array) ? parsed : nil
    else
      nil
    end
  rescue JSON::ParserError
    nil
  end

  def metadata_must_be_hash_or_valid_json
    return if metadata.blank? || metadata.is_a?(Hash)

    return if metadata.is_a?(String) && parse_json_hash(metadata).is_a?(Hash)

    errors.add(:metadata, "must be valid JSON")
  end

  def document_json_fields_must_be_arrays
    { subheadings: subheadings, body: body, images: images, youtube_id: youtube_id }.each do |field, value|
      next if value.blank? || value.is_a?(Array)
      next if value.is_a?(String) && parse_json_array(value).is_a?(Array)

      errors.add(field, "must be a JSON array")
    end
  end
end
