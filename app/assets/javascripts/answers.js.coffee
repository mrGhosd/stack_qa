$ ->
  $(".add-answer").click ->
    if $(".answer-form.row").length > 0
      $(".answer-form.row").remove()
    else
      question = $(this).data("question")
      $.get "/questions/#{question}/answers/new", (html) ->
        console.log html
        $(".question-action").append(html)

$(document).delegate("#new_answer", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  question = $("#new_answer .submit-answer").data("question")
  $.ajax "/questions/#{question}/answers",
    type: "POST"
    data: $("#new_answer").serialize()
    success: (data)->
      $(".answers-list").append("<div class='answer-item'><span class='text'>#{data.text}</span><span class='time'>#{data.created_at}</span></div>")
      $(".answer-form.row").remove()
    error: (error) ->
      object = JSON.parse(error.responseText)
      console.log object.text
      $("#new_answer textarea").addClass("error")
      $("#new_answer textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)