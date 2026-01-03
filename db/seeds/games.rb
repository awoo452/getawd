Game.create!(
  id: 1,
  game_name: "Test Game 1 (Playthrough Title)",
  game_title: "Test Game 1 (Series Title)",
  start_date: Date.current,
  game_notes: "Test Game 1",
  game_type: "some_tag, some_other_tag",
  game_image: "game1.png",
  progress_data: {
    stats: {},
    quick_info: [],
    achievements: []
  },
  show_to_public: true,
  created_at: Time.current,
  updated_at: Time.current
)
