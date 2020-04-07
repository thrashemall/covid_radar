# VCR=1 rspec
VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr')
  config.hook_into :webmock
  config.default_cassette_options = {
    allow_playback_repeats: true,
    record: ENV['VCR'] ? :new_episodes : :none
  }
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  config.ignore_request do |request|
    request.uri.start_with?(Settings.dig(:elasticsearch_url))
  end
end
