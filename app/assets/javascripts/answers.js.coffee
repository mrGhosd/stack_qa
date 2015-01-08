$ ->
  $(".add-answer").click ->
    if $(".answer-form.row").length > 0 || $(".comment-form").length > 0
      $(".answer-form.row").remove()
      $(".comment-form").remove()
    else
      question = $(this).data("question")
      $.get "/questions/#{question}/answers/new", (html) ->
        $(".question-action").append(html)
        $(".redactor").redactor(
          imageFloatMargin: '10px',
          imageGetJson: false
          imageUpload: '/redactor_rails/pictures'
          imageUploadParam: 'file'
          fileUpload: true
          fileUploadParam: 'file'
          clipboardUpload: true
          clipboardUploadUrl: false
          dragUpload: true
          dnbImageTypes: ['image/png', 'image/jpeg', 'image/gif']
          imageResizable: true
        )

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
      $(html).insertAfter($(button).closest(".answer-item"))
      $(item).hide()
      $(".redactor").redactor(
        imageFloatMargin: '10px',
        imageGetJson: false
        imageUpload: '/redactor_rails/pictures'
        imageUploadParam: 'file'
        fileUpload: true
        fileUploadParam: 'file'
        clipboardUpload: true
        clipboardUploadUrl: false
        dragUpload: true
        dnbImageTypes: ['image/png', 'image/jpeg', 'image/gif']
        imageResizable: true
      )
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
      $(".answers-list").prepend JST["templates/answer"](answer: data)
      $(".answer-form.row").remove()
    error: (error) ->
      object = JSON.parse(error.responseText)
      $("#new_answer textarea").addClass("error")
      $("#new_answer textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)