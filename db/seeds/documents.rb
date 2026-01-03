Document.create!(
  id: 1,
  title: "How to Use the Documents Section",
  slug: "level-1-rewards",
  subheadings: [
    "Purpose",
    "Adding New Documents",
    "Adding Images",
    "Optional Video Embeds",
    "Metadata"
  ],
  body: [
    "Explains what the Documents section is for.",
    "Each document uses aligned arrays for content.",
    "Images live in S3 under documents/{id}/{index}.png.",
    "YouTube IDs are embedded automatically.",
    "Optional metadata appears at the bottom."
  ],
  images: [
    { alt: "Documents layout", file: "0.png", caption: "General display image" },
    { alt: "Document ID", file: "1.png", caption: "Index alignment example" }
  ],
  youtube_id: ["GjLzI13gYhw"],
  metadata: { version: "1.0", category: "Documentation" },
  created_at: Time.current,
  updated_at: Time.current
)