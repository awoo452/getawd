Project.create!(
  id: 1,
  title: "1998 on the High Road",
  description: "A bar conversation about the importance of having a plan when doing things like signing up for a half marathon.",
  image: "project1.png",
  url: "https://www.amazon.com/dp/B0FFY8G5D2",
  featured: true,
  created_at: Time.zone.parse("2025-06-30 16:39:49.179081"),
  updated_at: Time.zone.parse("2025-06-30 16:39:49.179081")
)

Project.create!(
  id: 2,
  title: "GuacAMole",
  description: "This started as a freeCodeCamp Whack-a-Mole tutorial and immediately went off the rails - in a good way. I followed the core idea just long enough to understand it, then twisted it into something a little dumber, a little funnier, and more my own. It was one of the first times JavaScript really clicked for me beyond just following steps, and it set the tone for how I like to learn: build the thing, then mess with it until it breaks or becomes interesting.",
  image: "project2.png",
  url: "https://master.d2rge8c7efug7r.amplifyapp.com/",
  featured: false,
  service_type: "amplify_site",
  created_at: Time.zone.parse("2024-10-21 02:20:46.126642"),
  updated_at: Time.zone.parse("2026-02-21 20:14:44.592931")
)

Project.create!(
  id: 3,
  title: "Beard Bros Dumpsters",
  description: "This Rails application was developed to support a Pennsylvania-based company that offers dumpster rental services, including delivery and junk removal assistance in the surrounding area. The app streamlines the booking process for customers while providing the business with essential tools to manage their operations efficiently. With a user-friendly interface, it allows residents and businesses alike to easily schedule rentals and junk removal, ensuring a seamless experience for both parties. The project reflects a commitment to enhancing service accessibility and operational effectiveness in the local community.",
  image: "project3.png",
  url: "https://www.beardbrosdumpsters.com/",
  featured: false,
  service_type: "custom_rails_app",
  created_at: Time.zone.parse("2024-10-21 02:20:46.13121"),
  updated_at: Time.zone.parse("2024-10-21 02:20:46.13121")
)

Project.create!(
  id: 4,
  title: "closeenoughfabrication",
  description: "This is a website I regularly contribute to, showcasing one of my favorite hobbies outside of web development! It is a site dedicated to sharing some of my favorite 4x4 and off-road related work. Check it out at the link below, or you can also follow @closeenoughfabrication on Instagram for more frequent updates on what's happening in the shop.",
  image: "project4.png",
  url: "https://www.closeenoughfabrication.com",
  featured: false,
  service_type: "custom_rails_app",
  created_at: Time.zone.parse("2024-10-21 02:20:46.136424"),
  updated_at: Time.zone.parse("2024-10-21 02:20:46.136424")
)

Project.create!(
  id: 5,
  title: "Game Boy DMG-001",
  description: "A pixel-accurate-ish recreation of the original Nintendo Game Boy shell built with pure HTML, CSS, and a small amount of vanilla JavaScript. This project is less about gameplay and more about obsessive layout, spacing, and recreating the feel of old hardware in the browser. Right now it powers on, lights up, and plays the classic Nintendo boot animation. Long term, this is a sandbox for experimenting with browser-based UI, animations, and eventually interactive elements.",
  image: "project5.png",
  url: "https://master.d3dcxsy0hkmbvn.amplifyapp.com/",
  featured: true,
  service_type: "amplify_site",
  created_at: Time.zone.parse("2026-02-21 20:14:50.642531"),
  updated_at: Time.zone.parse("2026-02-21 20:14:50.642531")
)

Project.create!(
  id: 6,
  title: "Blackjack",
  description: "A straightforward browser-based Blackjack game built with vanilla JavaScript. This one focuses on game logic, state management, and user interaction rather than visuals. Deck handling, scoring, win/loss conditions, and basic flow are all handled client-side with no libraries doing the heavy lifting. It's intentionally simple and serves as a clean base to expand rules, UI, or add enhancements over time.",
  image: "project6.png",
  url: "https://main.d393qfhu5aoav7.amplifyapp.com/",
  featured: false,
  service_type: "amplify_site",
  created_at: Time.zone.parse("2026-02-21 20:14:57.48116"),
  updated_at: Time.zone.parse("2026-02-21 20:14:57.48116")
)

Project.create!(
  id: 7,
  title: "Pickled Pirates Racing",
  description: "Pickled Pirates Racing is a custom website built to support a racing team better known as some of my best friends. The site aims to deliver a clean public presence, simple content updates, and reliable performance. The project focused on practical delivery: clear information architecture, mobile-friendly pages, and a lightweight stack that is easy to maintain over time. The site was designed to highlight, race activity, community updates, and a full product catalog without overengineering the content workflow. From a build perspective, the work emphasized predictable behavior, fast load times, and straightforward deployment so updates can ship quickly without introducing fragility.",
  image: "project7.png",
  url: "https://pickledpiratesracing.com",
  featured: true,
  service_type: "custom_rails_app",
  created_at: Time.zone.parse("2026-02-04 18:22:03.922047"),
  updated_at: Time.zone.parse("2026-02-04 18:22:03.922047")
)

Project.create!(
  id: 10,
  title: "Daily Task & Rewards System",
  description: "Built a deterministic daily task and rewards system centered around task priority and same-day completion. Tasks are grouped into daily priority levels and rendered through a custom calendar interface. Completing all tasks for a given level on the day they are due earns a reward for that level. Rewards follow a full lifecycle (earned, redeemed, completed) and are tracked immutably for historical reference. The system prevents retroactive reward creation, avoids cross-level reward leakage, and enforces strict same-day eligibility rules. Recurring goals generate daily tasks automatically, and rewards are redeemed manually without overwriting prior state.",
  image: "logo-classic.png",
  url: "https://youtu.be/fj-JZnQEi3A",
  featured: false,
  service_type: "custom_rails_app",
  created_at: Time.zone.parse("2025-12-23 05:23:47.57003"),
  updated_at: Time.zone.parse("2026-01-08 05:09:00.194657")
)

Project.create!(
  id: 11,
  title: "Pickled Pirates @ Estranged Drags 2025",
  description: "Pickled Pirates @ Estranged Drags is a YouTube series capturing the chaos, camaraderie, and burnout-fueled fun of the crew at the Estranged Drags event. From late-night wrenching to questionable decisions, it's a raw look at the garage life, friendships, and the ridiculous moments that make it all worth filming. The series wraps up this week with the final episode dropping soon.",
  image: "logo-classic.png",
  url: "https://www.youtube.com/playlist?list=PLHno3IJ04is9JqvNUQy7okbXrkcqyJMLm",
  featured: false,
  created_at: Time.zone.parse("2025-10-07 18:35:00.340425"),
  updated_at: Time.zone.parse("2025-10-07 18:35:00.340425")
)
