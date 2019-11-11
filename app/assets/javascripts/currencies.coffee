App.room = App.cable.subscriptions.create "RateNotificationsChannel",
  received: (data) ->
    $('#rate-value h2').replaceWith data['rvalue']