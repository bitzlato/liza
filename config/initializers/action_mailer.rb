ActionMailer::Base.smtp_settings = {
  address: ENV['SMTP_HOST'],
  port: ENV['SMTP_POST'],
  user_name: ENV['SMTP_USER'],
  password: ENV['SMTP_PASSWORD']
}.delete_if { |k,v| v.blank? }
