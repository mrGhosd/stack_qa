$ ->
  $(".delete-question").click ->
    link = $(this).closest(".question-item")
    id = $(this).data("question")
    $.ajax "/questions/#{id}",
      type: "DELETE"
      success: ->
        link.fadeOut('slow')


$(document).delegate("#new_question", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  question = $("#new_answer .submit-answer").data("question")
  $.ajax "/questions",
    type: "POST"
    data: $("#new_question").serialize()
    success: (data)->
      window.location.href = "/"
    error: (error) ->
      console.log error
      object = error.responseJSON
      $.each(object, (key, value)->
        $("#new_question #question_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")
      )
)