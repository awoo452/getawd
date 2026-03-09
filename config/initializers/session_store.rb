session_options = {
  key: "_getawd_session",
  same_site: :lax,
  secure: Rails.env.production?
}

if Rails.env.production?
  session_options[:expire_after] = 2.years
end

Rails.application.config.session_store :cookie_store, **session_options
