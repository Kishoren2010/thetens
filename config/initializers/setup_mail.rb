ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "www.thetens.us",
  :user_name            => 'tambe257@gmail.com',
  :password             => 'V0g0nz!1977',
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "www.thetens.us"