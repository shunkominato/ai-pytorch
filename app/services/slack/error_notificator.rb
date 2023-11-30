# frozen_string_literal: true

  class Slack::ErrorNotificator
    def self.Notifice(user_id, error_location, err_message, value)
      notifier = Slack::Notifier.new(
        ENV['SLACK_WEBHOOK_URL'],
        channel: "test",
        username: 'error通知',
      )

      message = "
user_id: #{user_id}
error_location: #{error_location}
err_message: #{err_message}
#{value}"

      notifier.ping message
    end
  end