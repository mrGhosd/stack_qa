$ ->
  $(".delete-question").click ->
    link = $(this).closest(".question-item")
    id = $(this).data("question")
    $.ajax "/questions/#{id}",
      type: "POST"
      method: "DELETE"
      success: ->
        link.fadeOut('slow')


  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $(".questions-list").prepend JST["templates/question"](question: question)


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
