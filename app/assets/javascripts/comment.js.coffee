class Comment

  initialize: ->

  addComment: (button) ->
    type = $(button).data("type")
    if $(".comment-form").length > 0 || $(".answer-form.row").length > 0
      $(".comment-form").remove()
      $(".answer-form.row").remove()
    else
      if type == "Answer"
        question = $(button).data("question")
        answer = $(button).data("answer")
        url = "/questions/#{question}/answers/#{answer}/comments/new"
      else if type == "Question"
        question = $(button).data("question")


      template = JST["templates/comment_form"](form: {question: question, answer: answer, type: type, action: "Create"})
      if type == "Answer"
        $(".answer-actions").append(template)
      else if type == "Question"
        $(".question-action").append(template)


  editComment: (button)->

  removeComment: (button) ->

  submitForm: (form) ->
    submit_button = $(form).find(".submit-comment")
    text_field = $(form).find(".comment-text")
    type = $(submit_button).data("type")
    question = $(submit_button).data("question")
    console.log type + " " + question
    if type == "Answer"
      answer = $(submit_button).data("answer")
      url = "/questions/#{question}/answers/#{answer}/comments"
    else if type == "Question"
      url = "/questions/#{question}/comments"

    $.ajax url,
      type: "POST"
      data: {comment: {text: $(text_field).val()}, type: type}
      success: (response, request) ->
        console.log response
        console.log request
      error: (error) ->
        object = JSON.parse(error.responseText)
        $(".comment-form textarea").addClass("error")
        $(".comment-form textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")

# форму лучше держать в на странице
$ ->
  comment = new Comment()

  $(".add-comment").click ->
    comment.addComment($(this))

  $(document).delegate(".comment-form", "submit", (event)->
    event.preventDefault()
    event.stopPropagation()
    comment.submitForm($(this))
  )

  question = $(".answers-list").data("question")
  PrivatePub.subscribe "/questions/#{question}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    $(".comments-list").prepend JST["templates/comment"](comment: comment)
    $(".comment-form").remove()

  PrivatePub.subscribe "/questions/#{question}/answers/comments/create", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    console.log comment
    $.each($(".answer-item"), (key, value) ->
      if comment.commentable_id == $(value).data("answer")
        $(".comment-form").remove()
        $(value).find(".answer-comments-list").prepend JST["templates/comment"](comment: comment)
#        $(value).fadeOut('slow').replaceWith(JST["templates/comment"](comment: comment)).fadeIn('slow')
    )
#    $(".comments-list").prepend JST["templates/comment"](comment: comment)
#    $(".comment-form").remove()



#  $(".edit-comment").click ->
#    question = $(this).data("question")
#    comment = $(this).data("comment")
#    button = $(this)
#    item = button.closest('.comment-item')
#    $.get "/questions/#{question}/comments/#{comment}/edit", (html) ->
#      $(html).insertAfter(item)
#      $(item).hide()
#      $(".comment-form .remove-edit-form").click ->
#        item.show()
#        $(".comment-form").remove()
#      $(".comment-form .submit-comment").click (event)->
#        event.preventDefault()
#        event.stopPropagation()
#        event.stopImmediatePropagation()
#        $.ajax "/questions/#{question}/comments/#{comment}",
#          type: "PUT"
#          data: $(".comment-form").serialize()
#          success: (data) ->
#            $(".comment-form").remove()
#            item.remove()
#            $(".comments-list").prepend JST["templates/comment"](comment: data)
#          error: (error) ->
#            object = JSON.parse(error.responseText)
#            $(".comment-form textarea").addClass("error")
#            $(".comment-form textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
#
#  $(".remove-comment").click ->
#    question = $(this).data("question")
#    comment = $(this).data("comment")
#    item = $(this).closest(".comment-item")
#    $.ajax "/questions/#{question}/comments/#{comment}",
#      type: "DELETE"
#      success: ->
#        $(item).fadeOut('slow')
#

#
#  PrivatePub.subscribe "/questions/#{question}/comments/edit", (data, channel) ->
#    comment = $.parseJSON(data['comment'])
#    $.each($(".comment-item"), (key, value) ->
#      if comment.id == $(value).data("comment")
#        $(".comment-form").remove()
#        $(value).fadeOut('slow').replaceWith(JST["templates/comment"](comment: comment)).fadeIn('slow')
#    )



