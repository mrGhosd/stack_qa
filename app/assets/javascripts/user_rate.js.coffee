$ ->
  user = $(".user_profile_link").data("user")
  PrivatePub.subscribe "/users/#{user}/rate", (data, channel) ->
    
#    question = $.parseJSON(data['question'])
#    $(".questions-list").prepend JST["templates/question"](question: question)