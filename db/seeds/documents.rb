20.times do |i|
  Document.create!(
    title: "Seeded Document #{i + 1}",
    slug: "seeded-doc-#{i + 1}",
    subheadings: [
      "Purpose #{i + 1}",
      "Section A",
      "Section B"
    ],
    body: [
      "Seeded content for document #{i + 1}.",
      "More content for section A.",
      "More content for section B."
    ],
    images: [
      { alt: "Doc image #{i + 1}", file: "0.png", caption: "Seeded image" }
    ],
    youtube_id: [nil, "GjLzI13gYhw"].compact,
    metadata: { version: "1.0", category: "Seeded" },
    created_at: Time.current,
    updated_at: Time.current
  )
end
