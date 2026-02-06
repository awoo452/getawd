# Seed documentation records for the Documents section.

DOCUMENTS = [
  {
    slug: "how-to",
    title: "How to Use the Documents Section",
    subheadings: [
      "Purpose",
      "Adding New Documents",
      "Adding Images",
      "Optional Video Embeds",
      "Metadata"
    ],
    body: [
      "The Documents area stores guides, reference material, and instructions that need structured text with images and optional video embeds.",
      "Each document includes a title, a subheadings array, a matching body array, and an images array. Indexes align: subheadings[0] pairs with body[0] and images[0].",
      "Images live in S3 under documents/{id}/{file}. The database stores only file, alt text, and caption. document_image_url builds the key; if file is logo-classic.png, it maps to branding/logo-classic.png.",
      "If youtube_id contains YouTube IDs, the show page embeds each one automatically.",
      "Metadata is optional JSON and renders as a formatted list at the bottom of the document."
    ],
    images: [
      { "alt" => "Documents layout", "file" => "0.png", "caption" => "General layout for the Documents section." },
      { "alt" => "Document ID", "file" => "1.png", "caption" => "Subheadings, body, and images align by index." },
      { "alt" => "S3 structure", "file" => "2.png", "caption" => "Images stored in documents/{id}/{file}." },
      { "alt" => "Video embed example", "file" => "3.png", "caption" => "Use an array of YouTube IDs." }
    ],
    youtube_id: ["GjLzI13gYhw"],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "gaming-how-to",
    title: "How to Use the Gaming Section",
    subheadings: [
      "Purpose",
      "Game Naming",
      "Game Types",
      "Media Fields",
      "Progress Data",
      "Public Visibility"
    ],
    body: [
      "The Gaming section tracks individual playthroughs or series. Each record is a single playthrough or series, not the full history of a franchise.",
      "game_name is the playthrough title (series or episode range). game_title is the base game name and should be consistent across playthroughs.",
      "game_type lists two or three genres. It is descriptive only and does not change logic.",
      "game_image is stored in S3 under games/{id}/{file}. The database stores only the filename. youtube_id is a single video ID, and youtube_playlist_id is used for a playlist embed.",
      "progress_data expects three keys: stats (key-value map), quick_info (array of notes), and achievements (array of {text, url} or plain strings).",
      "show_to_public controls visibility. False hides a game everywhere on the public site. True makes it visible on index and show pages."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "rewards-system-hierarchy",
    title: "Rewards | System Hierarchy (Maslow-Based)",
    subheadings: [
      "Why This System Uses Maslow's Hierarchy",
      "Level 1: Physiological Needs",
      "Level 2: Safety and Stability",
      "Level 3: Growth, Mastery, and Belonging",
      "Level 4: Esteem and Long-Term Identity",
      "Level 5: Self-Actualization (Future State)",
      "Non-Negotiable Rules"
    ],
    body: [
      "This system is explicitly designed around Maslow's hierarchy of needs. The intent is to prevent basic life failure before allowing complexity or ambition.",
      "Level 1 represents physiological needs. These tasks must be completed before any higher level is evaluated.",
      "Level 2 represents safety and stability tasks. Level 2 rewards are only evaluated after Level 1 is complete.",
      "Level 3 represents growth, mastery, and belonging through consistency.",
      "Multiple level rewards may be earned on the same day if all tasks associated with each level are completed.",
      "Level reward uniqueness is enforced per day and per level. Redeeming a reward never blocks earning future rewards on later days.",
      "Task-level rewards are independent and never consume level rewards."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "rewards" }
  },
  {
    slug: "level-1-rewards",
    title: "Rewards | Level 1",
    subheadings: [
      "What Level 1 Is",
      "Level 1 Goals",
      "How Level 1 Works Daily",
      "Task-Level Rewards (Level 1 Only)",
      "Completion Rules",
      "What Level 1 Is Not"
    ],
    body: [
      "Level 1 represents the minimum daily obligations required to stay functional. These tasks exist to prevent silent degradation.",
      "Level 1 goals represent basic physiological and dependency needs. They are recurring, priority 1, and never manually created.",
      "At local midnight, one task per Level 1 goal is generated automatically for the day.",
      "Individual Level 1 tasks may grant small immediate rewards when completed. These rewards are intentionally minor and exist to reduce friction for basic care tasks.",
      "Completing all Level 1 tasks for the day earns the Level 1 reward. Task-level rewards do not bypass or replace the level reward.",
      "Level 1 is not optimization, streak tracking, or performance. The objective is baseline stability before anything else is allowed."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: ["fj-JZnQEi3A"],
    metadata: { "version" => "1.21.26", "category" => "rewards" }
  },
  {
    slug: "level-2-rewards",
    title: "Rewards | Level 2",
    subheadings: [
      "What Level 2 Is",
      "Level 2 Goals",
      "How Level 2 Works Daily",
      "Completion Rules",
      "What Level 2 Is Not"
    ],
    body: [
      "Level 2 represents maintenance and personal health tasks that improve quality of life.",
      "Level 2 goals are recurring, priority 2, and generate daily tasks automatically.",
      "Level 2 rewards are only evaluated on days where all Level 1 tasks are completed.",
      "One Level 2 reward may be earned per day and is redeemed manually.",
      "Level 2 is not mandatory for survival and should never interfere with Level 1."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "rewards" }
  },
  {
    slug: "level-3-rewards",
    title: "Rewards | Level 3",
    subheadings: [
      "What Level 3 Is",
      "How Level 3 Tasks Work",
      "Daily Level 3 Rewards",
      "Banking Level 3 Rewards",
      "Why Level 3 Exists"
    ],
    body: [
      "Level 3 consists of long-term, identity-shaping efforts that require daily participation.",
      "Level 3 tasks are simple, repetitive, and intentionally boring. Consistency is the difficulty.",
      "Completing all Level 3 tasks for the day earns a Level 3 reward.",
      "Level 3 rewards are banked and redeemed intentionally rather than consumed immediately.",
      "Level 3 exists to remove decision fatigue and force consistency through monotony."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "rewards" }
  },
  {
    slug: "rewards-gaming",
    title: "Rewards | Gaming",
    subheadings: [
      "Purpose of Gaming Rewards",
      "How Gaming Rewards Are Earned",
      "How Gaming Rewards Are Redeemed",
      "Files and Systems Involved",
      "Design Constraints"
    ],
    body: [
      "Gaming rewards provide structured, guilt-free leisure without undermining discipline.",
      "Gaming rewards are earned through completion of level-scoped reward rules. Task-level rewards never grant games.",
      "Redeeming a gaming reward assigns a random game or a user-selected game depending on reward level.",
      "This system relies on Reward records, reward_payload JSON, Game visibility flags, and daily reward evaluation services.",
      "Gaming rewards must not be redeemable more than once per day per level. Task-scoped rewards never consume level rewards."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "rewards" }
  },
  {
    slug: "igtr",
    title: "Ideas -> Goals -> Tasks -> Rewards (System Flow)",
    subheadings: [
      "Purpose",
      "Ideas (Top-Level Context)",
      "Ideas Page View",
      "Goals (Intent and Structure)",
      "Tasks (Execution Layer)",
      "Rewards (Earned by Completion)",
      "Flow Summary",
      "Schema and Data Integrity"
    ],
    body: [
      "This document explains how the system is structured from high-level ideas down to daily execution and rewards.",
      "Ideas provide long-term context and grouping only. They are not executable by themselves and exist to organize goals.",
      "The Ideas page shows a single idea, a status legend, and a list of goals. Each goal displays title, description, status, and due date, and can expand to show related tasks.",
      "Goals define intent and organize work. They are tracked with status and due dates and link to the full goal view.",
      "Tasks are the only executable and completable entities in the system. They carry due dates, status, and completion logic.",
      "Rewards are created exclusively as a result of successful task completion rules. They are not manually created for arbitrary milestones.",
      "Flow: Idea -> Goals -> Tasks -> Completion -> Reward(s). If a step is missing, downstream entities do not occur.",
      "Task completion and reward creation depend on schema correctness. If rewards or task completion fail unexpectedly, verify schema parity between environments first."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.29", "category" => "how-to", "section" => "system-flow", "doc_date" => "2026/02/06" }
  },
  {
    slug: "poop-loop",
    title: "The Poop Loop",
    subheadings: [
      "What Is the Poop Loop?",
      "Daily Routine",
      "Why This Exists",
      "Images"
    ],
    body: [
      "The Poop Loop is the default one-mile walking route. It is a quick daily loop to get outside, move, and handle dog needs.",
      "This is the main consistent routine. Simple, repeatable, and easy to track.",
      "This document exists to capture routines and habits. It documents the small things that become important.",
      "This section contains images related to the Poop Loop, stored in S3 under documents/9/."
    ],
    images: [
      { "alt" => "Poop Loop map", "file" => "0.png", "caption" => "Standard 1-mile Poop Loop route." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "current-version",
    title: "Version 1.21.26 - Application State and Schema Stability",
    subheadings: [
      "Purpose of This Document",
      "Current Application Version",
      "Development Status",
      "Documentation Focus",
      "Future Additions"
    ],
    body: [
      "This document describes the current operational state of the application and what this version represents.",
      "The application is running Version 1.21.26.",
      "This version represents a return to schema-aligned stability after reward and task system refactors.",
      "Several production issues during this phase were caused by unapplied database migrations rather than application logic.",
      "Schema parity between environments is a hard requirement for task completion and reward creation to function correctly."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "video-how-to",
    title: "Video Creation and Publishing Workflow",
    subheadings: [
      "Purpose",
      "Raw Footage Storage",
      "Editing Process",
      "Final Output Storage",
      "Publishing",
      "Future Refinements"
    ],
    body: [
      "This document describes the workflow for creating, editing, storing, and publishing gaming videos so the process is consistent and repeatable.",
      "Raw gameplay footage should be stored on the external drive using this structure: G:\\Gaming\\{Game Title}\\{Save or Series Name}\\raw\\episode_##\\. Each episode gets its own folder. Raw files stay untouched so they can always be re-edited later.",
      "Editing is done in DaVinci Resolve. Create projects per game or per series as needed. Edit, cut, add overlays or text if desired, and prepare the final export.",
      "Final rendered videos should be stored at: G:\\Gaming\\{Game Title}\\{Save/Series Name}\\final\\{Episode Or Title}. This is the clean, ready-to-upload archive of completed videos.",
      "Publishing goes wherever needed (YouTube, playlists, shorts). Over time this will include publishing standards: thumbnails, titles, descriptions, tags, and update notes.",
      "This workflow will expand as documentation continues. Expect more detail, screenshots, and refinements as the real workflow evolves."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "obs-audio-checklist",
    title: "OBS Audio Sanity Checklist (When Everything Breaks)",
    subheadings: [
      "Purpose",
      "Stable Audio Rules",
      "What Not to Do",
      "Quick Recovery Checklist"
    ],
    body: [
      "This document exists to prevent audio setup rabbit holes when OBS audio breaks. It defines a minimal, stable configuration that prioritizes fast recovery over complex routing.",
      "OBS Settings -> Audio: disable all global audio devices. Desktop Audio, Desktop Audio 2, Mic/Aux, and Mic/Aux 2 should not be used. All audio must be added explicitly as sources. Game audio is captured via a dedicated source. The microphone is captured via a Mic Input Capture source. Audio monitoring is enabled only on Game Audio. The Monitoring Device is set to the soundbar and never left on Default.",
      "Do not rely on OBS global audio devices. Do not assume Windows defaults are stable. Do not use Default as an audio device anywhere in OBS. Do not enable monitoring on the microphone unless needed. If Desktop or Aux audio is populated, the configuration is already unstable.",
      "If audio meters move but no sound is heard: (1) confirm all global audio devices are disabled. (2) confirm audio is from explicit sources only. (3) Advanced Audio Properties: Game Audio set to Monitor and Output. (4) Settings -> Advanced: Monitoring Device set to the soundbar."
    ],
    images: [
      { "alt" => "Documentation placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.21.26", "category" => "how-to" }
  },
  {
    slug: "reports",
    title: "Reports: Accountability Reporting Overview",
    subheadings: [
      "Purpose",
      "Monthly Summary Panel",
      "Completion Chain",
      "Report Card Metrics",
      "How Data Is Calculated"
    ],
    body: [
      "The Reports page is a performance snapshot for task completion. It aggregates recent task activity into a month view, a weekly chain, and a report card grade.",
      "Monthly Summary pulls tasks within the current month and splits them into completed on time versus completed late. It also shows missed tasks and estimated minutes lost for overdue tasks that are not completed or on hold.",
      "Completion Chain shows the last 6 weeks. For each week it counts available tasks, completed tasks, missed tasks, and whether the week was fully completed.",
      "Report Card is a 6-week performance summary. It calculates completed versus available tasks and converts the completion rate into a letter grade (A-F).",
      "Calculations come from Tasks: completed tasks use completion_date, on-time means completion_date <= due_date, late means completion_date > due_date. Missed tasks are past due and not completed or on hold. Completion rate = completed / available."
    ],
    images: [
      { "alt" => "Reports purpose", "file" => "logo-classic.png", "caption" => "Accountability reporting for recent task performance." },
      { "alt" => "Monthly summary", "file" => "logo-classic.png", "caption" => "Current month breakdown for completions and misses." },
      { "alt" => "Completion chain", "file" => "logo-classic.png", "caption" => "Six-week chain of completed vs missed tasks." },
      { "alt" => "Report card", "file" => "logo-classic.png", "caption" => "Six-week completion rate with letter grade." },
      { "alt" => "Data calculations", "file" => "logo-classic.png", "caption" => "Definitions for on-time, late, missed, and completion rate." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.29", "category" => "how-to", "section" => "reports", "doc_date" => "2026/02/06" }
  },
  {
    slug: "s3-media-proxy",
    title: "S3 Media Proxy: How Images Are Served",
    subheadings: [
      "Purpose",
      "Proxy Route",
      "Key Format",
      "Presigned URLs",
      "Section Key Examples"
    ],
    body: [
      "All images are served through a local proxy that generates short-lived S3 presigned URLs. This avoids hardcoding public S3 URLs in views.",
      "Route: /media/*key. The helper s3_url(key) builds this path, which redirects to a presigned URL if the key exists.",
      "Keys are plain S3 object keys (no scheme, no bucket). Example: documents/12/0.png.",
      "Presigned URLs are generated on request and cached. If a key is blank, the proxy returns 404.",
      "Examples: documents/{id}/{file}, games/{id}/{game_image}, blog/{image}, projects/{image}, about/{index}.png, branding/logo-classic.png."
    ],
    images: [
      { "alt" => "Proxy purpose", "file" => "logo-classic.png", "caption" => "Media is served via /media/*key." },
      { "alt" => "Key format", "file" => "logo-classic.png", "caption" => "Keys are raw S3 object paths." },
      { "alt" => "Examples", "file" => "logo-classic.png", "caption" => "Common key patterns by section." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "media", "doc_date" => "2026/02/06" }
  },
  {
    slug: "videos",
    title: "Videos: Embeds, Listings, and Playback",
    subheadings: [
      "Purpose",
      "Index Page Listing",
      "Show Page Playback",
      "YouTube Embed Rules",
      "Data Fields"
    ],
    body: [
      "The Videos section is a simple YouTube embed library. Each record contains a title, description, and a YouTube video ID.",
      "The index page lists every video with an embedded player, title, and description. Pagination is shown when there are multiple pages.",
      "The show page displays a single video, its title, and description. If the YouTube ID is missing, the embed is omitted.",
      "Embeds use the YouTube iframe with rel=0. On index and show pages, autoplay can be toggled via the URL param autoplay=1.",
      "Fields: title (string), description (text), youtube_id (string)."
    ],
    images: [
      { "alt" => "Videos purpose", "file" => "logo-classic.png", "caption" => "Video library built from YouTube embeds." },
      { "alt" => "Index listing", "file" => "logo-classic.png", "caption" => "Index shows embedded players with titles and descriptions." },
      { "alt" => "Show view", "file" => "logo-classic.png", "caption" => "Show page displays a single embedded video." },
      { "alt" => "YouTube ID", "file" => "logo-classic.png", "caption" => "Use raw YouTube IDs, not full URLs." },
      { "alt" => "Data fields", "file" => "logo-classic.png", "caption" => "title, description, youtube_id map directly to the view." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "videos", "doc_date" => "2026/02/06" }
  },
  {
    slug: "home-featured",
    title: "Home Page Featured Content",
    subheadings: [
      "Purpose",
      "Featured Projects",
      "Featured Blog Posts",
      "Featured Videos",
      "Ordering"
    ],
    body: [
      "The home page highlights featured content from Projects, Blog Posts, and Videos.",
      "Projects appear if featured=true. All featured projects are shown on the home page.",
      "Blog posts appear if featured=true. All featured posts are shown on the home page.",
      "Videos appear if featured=true. Featured videos are ordered by most recent first.",
      "Ordering: Projects and Blog Posts are unordered in code; Videos are ordered by created_at DESC."
    ],
    images: [
      { "alt" => "Home featured", "file" => "logo-classic.png", "caption" => "Home sections pull from featured flags." },
      { "alt" => "Projects featured", "file" => "logo-classic.png", "caption" => "Project cards appear when featured=true." },
      { "alt" => "Blog featured", "file" => "logo-classic.png", "caption" => "Blog cards appear when featured=true." },
      { "alt" => "Video featured", "file" => "logo-classic.png", "caption" => "Videos ordered newest to oldest." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "home", "doc_date" => "2026/02/06" }
  },
  {
    slug: "blog-posts",
    title: "Blog Posts: Publishing and Display",
    subheadings: [
      "Purpose",
      "Index Listing",
      "Show Page Layout",
      "Images",
      "Data Fields"
    ],
    body: [
      "The Blog Posts section is a standard feed of long-form entries. Each post has a title, description, body, and optional image.",
      "The index page lists posts with title, description, optional image thumbnail, and a Read More link. Pagination is handled by the shared pagination partial.",
      "The show page renders a header (image, title, description) and a body block. Body content is formatted with simple_format for readable paragraphs.",
      "Images are optional. If present, they are pulled from S3 under the blog/ prefix and used in both the index card and the show header.",
      "Fields: title (string), description (text), body (text), image (string), featured (boolean), slug (string)."
    ],
    images: [
      { "alt" => "Blog purpose", "file" => "logo-classic.png", "caption" => "Long-form posts for updates and notes." },
      { "alt" => "Index listing", "file" => "logo-classic.png", "caption" => "List view shows title, description, and optional image." },
      { "alt" => "Show layout", "file" => "logo-classic.png", "caption" => "Header + body layout on the show page." },
      { "alt" => "Images", "file" => "logo-classic.png", "caption" => "Images live under blog/ in S3." },
      { "alt" => "Data fields", "file" => "logo-classic.png", "caption" => "title, description, body, image, featured, slug." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "blog-posts", "doc_date" => "2026/02/06" }
  },
  {
    slug: "projects",
    title: "Projects: Portfolio Listing",
    subheadings: [
      "Purpose",
      "Index Listing",
      "Show Page",
      "Images and Links",
      "Data Fields"
    ],
    body: [
      "The Projects section is a portfolio-style list of work. Each project has a title, description, optional image, and optional external URL.",
      "The index page lists projects with title, description, and optional image. Featured projects are highlighted when the flag is set.",
      "The show page presents a single project with full description and image if present.",
      "Images are optional and loaded from S3 under the projects/ prefix. The url field, if present, should link to the live project or repository.",
      "Fields: title (string), description (text), image (string), url (string), featured (boolean)."
    ],
    images: [
      { "alt" => "Projects purpose", "file" => "logo-classic.png", "caption" => "Portfolio entries for completed work." },
      { "alt" => "Index listing", "file" => "logo-classic.png", "caption" => "List view with optional images." },
      { "alt" => "Show page", "file" => "logo-classic.png", "caption" => "Single project detail view." },
      { "alt" => "Images and links", "file" => "logo-classic.png", "caption" => "Optional image and external URL." },
      { "alt" => "Data fields", "file" => "logo-classic.png", "caption" => "title, description, image, url, featured." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "projects", "doc_date" => "2026/02/06" }
  },
  {
    slug: "about",
    title: "About: Database-Backed Sections",
    subheadings: [
      "Purpose",
      "Data Source",
      "Rendering Order",
      "Images",
      "Data Fields"
    ],
    body: [
      "The About page is built from database-backed sections instead of static content.",
      "Sections are loaded from the about_sections table and rendered in a simple list.",
      "Each section shows a header and body in the order returned by the query. Ordering is controlled by position in the data.",
      "Section images are loaded from S3 under about/{index}.png and are paired by list position (1-based index).",
      "Fields: header (string), body (text), position (integer, unique)."
    ],
    images: [
      { "alt" => "About purpose", "file" => "logo-classic.png", "caption" => "About sections are stored in the database." },
      { "alt" => "Data source", "file" => "logo-classic.png", "caption" => "Rendered from about_sections." },
      { "alt" => "Rendering order", "file" => "logo-classic.png", "caption" => "Position controls order." },
      { "alt" => "Images", "file" => "logo-classic.png", "caption" => "Images come from about/{index}.png." },
      { "alt" => "Data fields", "file" => "logo-classic.png", "caption" => "header, body, position." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "about", "doc_date" => "2026/02/06" }
  },
  {
    slug: "contact",
    title: "Contact: Form and Social Links",
    subheadings: [
      "Purpose",
      "Contact Form",
      "Spam Protection",
      "Message Delivery",
      "Social Links",
      "Data Sources"
    ],
    body: [
      "The Contact page provides a simple form for inquiries and a list of social links.",
      "The form collects name, email, and a message. All fields are required.",
      "A hidden website field acts as a honeypot. If it is filled, the controller returns early and does nothing.",
      "Submissions call Contact::SendMessage, which delivers the email through ContactMailer.",
      "Social links are pulled from config/contact_info.yml under social_media and rendered only when present.",
      "Data sources: form params for messages, YAML config for social links."
    ],
    images: [
      { "alt" => "Contact purpose", "file" => "logo-classic.png", "caption" => "Simple inbound contact form." },
      { "alt" => "Contact form", "file" => "logo-classic.png", "caption" => "Name, email, message required." },
      { "alt" => "Honeypot", "file" => "logo-classic.png", "caption" => "Hidden field blocks bots." },
      { "alt" => "Delivery", "file" => "logo-classic.png", "caption" => "Messages are emailed via service." },
      { "alt" => "Social links", "file" => "logo-classic.png", "caption" => "Links loaded from contact_info.yml." },
      { "alt" => "Data sources", "file" => "logo-classic.png", "caption" => "Form params and YAML config." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "contact", "doc_date" => "2026/02/06" }
  },
  {
    slug: "landscaping",
    title: "Landscaping: Public Job Listings",
    subheadings: [
      "Purpose",
      "Data Source",
      "Images",
      "Contact Link"
    ],
    body: [
      "The Landscaping page is a public-facing list of landscaping jobs.",
      "Jobs are loaded from the landscaping_jobs table and rendered in a simple list.",
      "Images are optional and loaded from S3 under landscaping/{image}.",
      "The page links to the Contact form for inquiries."
    ],
    images: [
      { "alt" => "Landscaping purpose", "file" => "logo-classic.png", "caption" => "Public list of landscaping jobs." },
      { "alt" => "Images", "file" => "logo-classic.png", "caption" => "Images come from landscaping/{image}." },
      { "alt" => "Contact", "file" => "logo-classic.png", "caption" => "Inquiries go through the contact form." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "landscaping", "doc_date" => "2026/02/06" }
  },
  {
    slug: "blackjack",
    title: "Blackjack: Mini Game",
    subheadings: [
      "Purpose",
      "Session State",
      "Betting and Deal Flow",
      "Actions",
      "Reset Rules"
    ],
    body: [
      "Blackjack is a simple session-backed mini game.",
      "State is stored in session: deck, player hand, dealer hand, chips, bet, and game state.",
      "You must place a bet before dealing. Dealing starts the round and sets state to player_turn.",
      "Actions: bet, clear bet, deal, hit, stand. Payouts follow standard blackjack rules with a 3:2 bonus on natural blackjack.",
      "Reset clears hands and reshuffles. Hard reset restores chips to 100 when broke."
    ],
    images: [
      { "alt" => "Blackjack purpose", "file" => "logo-classic.png", "caption" => "Session-backed blackjack mini game." },
      { "alt" => "Controls", "file" => "logo-classic.png", "caption" => "Bet, deal, hit, stand, reset." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "blackjack", "doc_date" => "2026/02/06" }
  },
  {
    slug: "feedback-board",
    title: "Feedback Board: Capture, Track, and Close the Loop",
    subheadings: [
      "Purpose",
      "Open vs Completed Lists",
      "Adding New Feedback",
      "Completing Feedback",
      "Field Reference and Data Notes"
    ],
    body: [
      "The Feedback section is a lightweight queue for ideas, fixes, and site polish. It captures quick notes with enough context to act on later.",
      "The index splits items into Open and Completed. Open shows the short description. Completed hides the body and shows the commit reference when present.",
      "Use the New Feedback form to log an item quickly. Title is required. Section is optional and should be the area of the site. Details is optional but recommended.",
      "To mark something as done, edit the feedback entry and set it to completed, and add a commit reference if the fix is in version control.",
      "Fields: title (required), section (optional tag), body (optional detail), completed (boolean), commit_ref (optional SHA or PR reference)."
    ],
    images: [
      { "alt" => "Feedback purpose", "file" => "logo-classic.png", "caption" => "Capture small fixes and ideas quickly." },
      { "alt" => "Open and completed lists", "file" => "logo-classic.png", "caption" => "The page splits entries into Open and Completed lists." },
      { "alt" => "New feedback form", "file" => "logo-classic.png", "caption" => "Title is required; section and details add context." },
      { "alt" => "Completing feedback", "file" => "logo-classic.png", "caption" => "Completed entries can include a commit reference." },
      { "alt" => "Field reference", "file" => "logo-classic.png", "caption" => "Short, structured fields keep the list scannable." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "feedback", "doc_date" => "2026/02/06" }
  },
  {
    slug: "dashboard",
    title: "Dashboard: Overview and Panels",
    subheadings: [
      "Purpose",
      "Summary Panel",
      "Ideas Panel",
      "Goals Panel",
      "Tasks Panels",
      "Data Sources"
    ],
    body: [
      "The Dashboard is the signed-in landing view. It summarizes goals, tasks, rewards, and idea activity for the current day.",
      "The Summary panel shows total goal and task counts by status, due-today counts by status, time remaining (estimated minus actual minutes), and reward totals with links to Rewards.",
      "The Ideas panel shows each idea with an emoji and a color based on the most recent completed task: green (today), yellow (1-2 days), red (3-6 days), black (7+ days), gray (inactive). It also aggregates completed, upcoming, and partial minutes.",
      "The Goals panel lists in-progress, not-started, and completed goals using the shared goal card display.",
      "The Tasks panels show in-progress, not-started, on-hold, and completed tasks using the shared task card display.",
      "Data is aggregated by Dashboard::IndexData, which queries tasks, goals, rewards, and idea/task rollups. Icons come from GOAL_ICONS and emojis from IDEAS."
    ],
    images: [
      { "alt" => "Dashboard summary", "file" => "logo-classic.png", "caption" => "Dashboard panels and summary data." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "dashboard", "doc_date" => "2026/02/06" }
  },
  {
    slug: "calendar",
    title: "Calendar: Daily and Monthly Tasks",
    subheadings: [
      "Purpose",
      "Daily View",
      "Monthly View",
      "Levels and Links",
      "Data Scope"
    ],
    body: [
      "The Calendar shows tasks due in the current month with a daily snapshot and a monthly grid.",
      "Daily view groups tasks by priority level (1-10) for the selected day and lists tasks with icons and time status.",
      "Monthly view renders a calendar grid by due_date and lists tasks per day, sorted by priority.",
      "Each level header links to doc_path('level-#{level}-rewards'). Levels beyond 3 can appear in the calendar but the Rewards page highlights only Levels 1-3.",
      "Tasks are loaded for the current month using due_date between beginning_of_month and end_of_month."
    ],
    images: [
      { "alt" => "Calendar views", "file" => "logo-classic.png", "caption" => "Daily and monthly task calendar." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "calendar", "doc_date" => "2026/02/06" }
  },
  {
    slug: "ideas",
    title: "Ideas: Goals and Task Overview",
    subheadings: [
      "Purpose",
      "Page Layout",
      "Goal Summary",
      "Task Detail Toggle",
      "Data Source"
    ],
    body: [
      "Ideas provide high-level context and group related goals.",
      "The Ideas show page renders a status legend, the idea title, and a list of related goals.",
      "Each goal displays title, description, status, and due date, with links to full goal pages.",
      "Tasks are shown in a details toggle under each goal with task name, description, due date, and status.",
      "Data is loaded by Ideas::ShowData, which includes goals and their tasks and derives an emoji from the IDEAS map."
    ],
    images: [
      { "alt" => "Ideas overview", "file" => "logo-classic.png", "caption" => "Idea detail with goals and tasks." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "ideas", "doc_date" => "2026/02/06" }
  },
  {
    slug: "goals",
    title: "Goals: Kanban and Detail Views",
    subheadings: [
      "Purpose",
      "Index (Kanban)",
      "Goal Details",
      "Fields",
      "Status and Hold Rules"
    ],
    body: [
      "Goals define intent and organize tasks under an Idea.",
      "The Goals index groups cards by status (in progress, not started, on hold, completed) and displays title, description, priority, and due date.",
      "The Goal show page displays full details including SMART fields, status, hold-until date, and completed_at.",
      "Fields include title, description, due_date, priority, category, status, recurring, hold_until, completed_at, and SMART attributes.",
      "Status is an enum. On-hold goals may show a reopen date if hold_until is set."
    ],
    images: [
      { "alt" => "Goals kanban", "file" => "logo-classic.png", "caption" => "Status columns for goal tracking." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "goals", "doc_date" => "2026/02/06" }
  },
  {
    slug: "tasks",
    title: "Tasks: Kanban, Detail, and Completion",
    subheadings: [
      "Purpose",
      "Index (Kanban)",
      "Task Details",
      "Filters and Sorting",
      "Completion and Rewards"
    ],
    body: [
      "Tasks are the executable units in the system and can optionally belong to a goal.",
      "The Tasks index groups cards by status (in progress, not started, on hold, completed) and shows key fields like priority and due date.",
      "The Task show page renders full details, SMART fields, hold-until date, assigned_to, estimated time, actual time, and an optional goal link.",
      "Index filters include status, due date, goal_id, and search by task_name. Sorting supports task_name, status, priority, and due_date.",
      "When a task transitions to completed, Tasks::HandleCompletion evaluates task rewards and daily level rewards based on priority and completion_date."
    ],
    images: [
      { "alt" => "Tasks kanban", "file" => "logo-classic.png", "caption" => "Status columns for task tracking." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "tasks", "doc_date" => "2026/02/06" }
  },
  {
    slug: "rewards",
    title: "Rewards: Eligibility, Redemption, and History",
    subheadings: [
      "Purpose",
      "Eligibility Rules",
      "Level Rewards",
      "Task Rewards",
      "Reward History"
    ],
    body: [
      "Rewards are created from task completion and can be redeemed from the Rewards page.",
      "Eligibility requires all reward_rules satisfied, all linked tasks completed, and cooldown rules met. Reward.available is updated by eligibility checks.",
      "Level rewards are earned when all non-on-hold tasks of a given priority for today are completed. The top panel highlights Levels 1-3 and provides specific redemption flows.",
      "Task rewards are created when a task with eligible_reward is completed. Each task reward can be redeemed directly from the task rewards list.",
      "The Reward History section lists all earned, redeemed, and completed rewards and allows redeeming any earned reward, including level rewards not shown in the top panel."
    ],
    images: [
      { "alt" => "Rewards overview", "file" => "logo-classic.png", "caption" => "Rewards page sections and redemption flows." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "how-to", "section" => "rewards", "doc_date" => "2026/02/06" }
  },
  {
    slug: "level-4-rewards",
    title: "Rewards | Level 4",
    subheadings: [
      "What Level 4 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 4 Is Not"
    ],
    body: [
      "Level 4 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 4 are grouped together in the Calendar daily view under Level 4.",
      "If all non-on-hold Level 4 tasks due today are completed, a level reward can be earned for Level 4.",
      "Level 4 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 4 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 4 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-5-rewards",
    title: "Rewards | Level 5",
    subheadings: [
      "What Level 5 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 5 Is Not"
    ],
    body: [
      "Level 5 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 5 are grouped together in the Calendar daily view under Level 5.",
      "If all non-on-hold Level 5 tasks due today are completed, a level reward can be earned for Level 5.",
      "Level 5 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 5 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 5 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-6-rewards",
    title: "Rewards | Level 6",
    subheadings: [
      "What Level 6 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 6 Is Not"
    ],
    body: [
      "Level 6 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 6 are grouped together in the Calendar daily view under Level 6.",
      "If all non-on-hold Level 6 tasks due today are completed, a level reward can be earned for Level 6.",
      "Level 6 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 6 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 6 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-7-rewards",
    title: "Rewards | Level 7",
    subheadings: [
      "What Level 7 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 7 Is Not"
    ],
    body: [
      "Level 7 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 7 are grouped together in the Calendar daily view under Level 7.",
      "If all non-on-hold Level 7 tasks due today are completed, a level reward can be earned for Level 7.",
      "Level 7 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 7 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 7 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-8-rewards",
    title: "Rewards | Level 8",
    subheadings: [
      "What Level 8 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 8 Is Not"
    ],
    body: [
      "Level 8 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 8 are grouped together in the Calendar daily view under Level 8.",
      "If all non-on-hold Level 8 tasks due today are completed, a level reward can be earned for Level 8.",
      "Level 8 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 8 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 8 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-9-rewards",
    title: "Rewards | Level 9",
    subheadings: [
      "What Level 9 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 9 Is Not"
    ],
    body: [
      "Level 9 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 9 are grouped together in the Calendar daily view under Level 9.",
      "If all non-on-hold Level 9 tasks due today are completed, a level reward can be earned for Level 9.",
      "Level 9 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 9 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 9 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  },
  {
    slug: "level-10-rewards",
    title: "Rewards | Level 10",
    subheadings: [
      "What Level 10 Is",
      "How Tasks Are Grouped",
      "Daily Reward Behavior",
      "Redemption Notes",
      "What Level 10 Is Not"
    ],
    body: [
      "Level 10 is an optional priority tier for tasks beyond Levels 1-3.",
      "Tasks with priority 10 are grouped together in the Calendar daily view under Level 10.",
      "If all non-on-hold Level 10 tasks due today are completed, a level reward can be earned for Level 10.",
      "Level 10 rewards appear in Reward History and can be redeemed there. The top Level Rewards panel only highlights Levels 1-3.",
      "Level 10 is not a special reward payload level; redemption uses the default level reward payload."
    ],
    images: [
      { "alt" => "Level 10 placeholder", "file" => "logo-classic.png", "caption" => "Placeholder image." }
    ],
    youtube_id: [],
    metadata: { "version" => "1.23.30", "category" => "rewards" }
  }
].freeze

DOCUMENTS.each do |attrs|
  document = Document.find_or_initialize_by(slug: attrs[:slug])
  document.assign_attributes(attrs)
  document.save!
end
