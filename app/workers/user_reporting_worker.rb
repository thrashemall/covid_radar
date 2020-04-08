# frozen_string_literal: true

class UserReportingWorker < ApplicationWorker
  LOCK = 'user:reporting'

  def perform
    User.with_advisory_lock(LOCK, timeout_seconds: 0) do
      not_reported_users = User.not_reported.count
      return if not_reported_users.zero?

      SlackApi::Cli.new(channel: SlackApi::Cli::CHANNEL_USERS).post text: <<~TEXT
        New users: #{not_reported_users}
        Total users: #{User.count}
      TEXT

      User.not_reported.reported!
    end
  end
end
