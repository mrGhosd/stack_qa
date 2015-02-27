$ ->
  user = $(".user_profile_link").data("user")
  PrivatePub.subscribe "/users/#{user}/rate", (data, channel) ->
    stat = data.statistic
    $(".authentication-links .rating span.rate").html(stat.rate).fadeIn()
    if stat.rate < 0 && parseInt($(".rating span.rate").text(), 10) > 0
      $(".user-rate").removeClass(".glyphicon-thumbs-up").addClass(".glyphicon-thumbs-down")
    if stat.rate > 0 && parseInt($(".rating span.rate").text(), 10) < 0
      $(".user-rate").removeClass(".glyphicon-thumbs-down").addClass(".glyphicon-thumbs-up")



