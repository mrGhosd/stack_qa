$ ->
  $(".add-answer").click ->
    if $(".answer-form.row").length > 0
      $(".answer-form.row").remove()
    else
      question = $(this).data("question")
      $.get "/questions/#{question}/answers/new", (html) ->
        console.log html
        $(".question-action").append(html)

  $(".edit-answer").click ->
    $(".row.answer-form").remove()
    $(".answer-item").show()
    question = $(this).data("question")
    answer = $(this).data("answer")
    button = $(this)
    item = $(this).closest(".answer-item")
    console.log question
    console.log answer
    $.get "/questions/#{question}/answers/#{answer}/edit", (html) ->
      console.log html
      $(html).insertAfter($(button).closest(".answer-item"))
      $(item).hide()
      $(".answer-form .remove-edit-form").click ->
        item.show()
        $(".row.answer-form").remove()
      $(".edit_answer .submit-answer").click (event)->
        event.preventDefault()
        event.stopPropagation()
        event.stopImmediatePropagation()
        $.ajax "/questions/#{question}/answers/#{answer}",
          type: "PUT"
          data: $(".edit_answer").serialize()
          success: (data) ->
            $(".edit_answer").remove()
            item.remove()
            $(".answers-list").append JST["templates/answer"](answer: data)
          error: (error)->
            object = JSON.parse(error.responseText)
            $(".edit_answer textarea").addClass("error")
            $(".edit_answer textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")

  $(".remove-answer").click ->
    question = $(this).data("question")
    answer = $(this).data("answer")
    item = $(this).closest(".answer-item")
    $.ajax "/questions/#{question}/answers/#{answer}",
      type: "DELETE"
      success: ->
        $(item).fadeOut('slow')

$(document).delegate("#new_answer", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  question = $("#new_answer .submit-answer").data("question")
  $.ajax "/questions/#{question}/answers",
    type: "POST"
    data: $("#new_answer").serialize()
    success: (data)->
      $(".answers-list").append JST["templates/answer"](answer: data)
      $(".answer-form.row").remove()
    error: (error) ->
      object = JSON.parse(error.responseText)
      $("#new_answer textarea").addClass("error")
      $("#new_answer textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)