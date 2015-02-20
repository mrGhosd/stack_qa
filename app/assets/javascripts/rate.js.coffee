$ ->
  $(".rate-move").click ->
    changeRate($(this))


changeRate = (button) ->
  question = $(button).closest(".rate-block").data("question")
  answer = $(button).closest(".rate-block").data("answer")
  rate = $(button).data("rate")
  if answer
    url = "/questions/#{question}/answers/#{answer}/rate"
  else
    url = "/questions/#{question}/rate"

  $.ajax url,
    type: "POST"
    data: { rate: rate }
    success: (response, request)->
      $(button).closest(".rate-block").find(".rate-value").find("span").html(response.rate)
    error: (response, request) ->
      console.log response
      console.log request