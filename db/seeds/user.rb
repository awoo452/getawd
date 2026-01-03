User.create!(
  email: "test@test.com",
  password: "test123",
  password_confirmation: "test123",
  approved: true,
  created_at: Time.current,
  updated_at: Time.current
)
