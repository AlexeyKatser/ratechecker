class RateNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rate_notifications_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
