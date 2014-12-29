$ ->
  $(".add-answer").click ->
    question = $(this).data("question")
    $.get "/questions/#{question}/answers/new", (html) ->
      console.log html
      $(".question-action").append(html)
#      $(html).insertAfter($(this))

$(document).delegate("#new_answer", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  alert "1"
)