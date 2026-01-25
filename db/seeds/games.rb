types = [
  "rpg, adventure",
  "action, platformer",
  "strategy, sim",
  "puzzle, casual",
  "shooter, co-op",
  "roguelike, indie"
]

100.times do |i|
  Game.create!(
    game_name: "Playthrough #{i + 1}",
    game_title: "Test Game #{(i % 20) + 1}",
    start_date: Date.current - rand(0..90).days,
    completion_date: [nil, Date.current - rand(0..30).days].sample,
    game_notes: "Seeded notes for game #{i + 1}",
    game_type: types.sample,
    game_image: "game#{(i % 3) + 1}.png",
    progress_data: {
      stats: { hours: rand(1..80), deaths: rand(0..50) },
      quick_info: ["Seeded run #{i + 1}", "Mode: normal"],
      achievements: [
        { "text" => "Beat boss #{rand(1..5)}", "url" => "https://example.com/clip/#{i}" }
      ]
    },
    youtube_id: [nil, "Zrfsuu33IYI"].sample,
    youtube_playlist_id: [nil, "PL#{rand(1000..9999)}"].sample,
    show_to_public: [true, false].sample,
    created_at: Time.current,
    updated_at: Time.current
  )
end
