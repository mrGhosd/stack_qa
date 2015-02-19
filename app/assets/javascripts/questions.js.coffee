$ ->
  $(".delete-question").click ->
    link = $(this).closest(".question-item")
    id = $(this).data("question")
    $.ajax
      url: "/questions/#{id}"
      type: "DELETE"
      success: ->
        link.fadeOut('slow')

  $(".rate-move").click ->
    questionRate($(this))

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $(".questions-list").prepend JST["templates/question"](question: question)

  $(".sign-in-question").click ->
    signInQuestion($(this))

$(document).delegate(".question_form", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  $(".question_form input, .question_form textarea").removeClass("error")
  $(".error-text").remove()
  url
  type
  action = $("#question_action")

  if action.length > 0
    url = "/questions/#{action.data('question')}"
    type = "PATCH"
  else
    url = "/questions"
    type = "POST"

  $.ajax url,
    type: type
    data: $(".question_form").serialize()
    success: (data)->
      if action.length > 0
        window.location.href = "/questions/#{action.data('question')}"
      else
        window.location.href = "/"
    error: (error) ->
      console.log error
      object = error.responseJSON
      $.each(object, (key, value)->
        $(".question_form #question_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")
      )
  )


signInQuestion = (button)->
  question = button.data("question")
  $.ajax "/questions/#{question}/sign_in_question",
    type: "POST"
    success: (response, request) ->
      showMessage(response.message)
    error: (response, request)->
      showMessage(response.error)


questionRate = (button) ->
  question = $(button).closest(".rate-block").data("question")
  rate = $(button).data("rate")
  $.ajax "/questions/#{question}/rating",
    type: "POST"
    data: { rate: rate }
    success: (response, request) ->
      $(".rate-value span").html(response.rate)
    error: (response, request) ->
      console.log response
      console.log request
showMessage = (text) ->
  $("body").prepend JST["templates/modal"]
  $("#messageModal .modal-body").html(text)
  $("#messageModal").modal('show')