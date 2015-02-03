$ ->
  $(".add-comment").click ->
    addComment($(this))

  $(".edit-comment").click ->
    editComment($(this))

  $(document).delegate(".remove-comment-form", "click", (event) ->
    removeCommentForm($(this))
  )

  $(".remove-comment").click (event)->
    event.preventDefault()
    event.stopPropagation()
    removeComment($(this))

  $(document).delegate(".comment-form", "submit", (event)->
    event.preventDefault()
    event.stopPropagation()
    submitForm($(this))
  )

  question = $(".answers-list").data("question")
  PrivatePub.subscribe "/questions/#{question}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    $(".comments-list").prepend JST["templates/comment"](comment: comment)
    $(".comment-form").remove()

  PrivatePub.subscribe "/questions/#{question}/answers/comments/edit", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    updateComment(comment)


  PrivatePub.subscribe "/questions/#{question}/comments/edit", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    updateComment(comment)


  PrivatePub.subscribe "/questions/#{question}/answers/comments/create", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    console.log comment
    $.each($(".answer-item"), (key, value) ->
      if comment.commentable_id == $(value).data("answer")
        $(".comment-form").remove()
        $(value).find(".answer-comments-list").prepend JST["templates/comment"](comment: comment)
    )

updateComment = (comment)->
  $.each($(".comment-item"), (key, value) ->
    if $(value).data("comment") == comment.id
      template = JST["templates/comment"](comment: comment)
      $(value).after template
      $(value).remove()
      $(".comment-form").remove()
  )


addComment= (button)->
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

    template = JST["templates/comment_form"](form: {question: question, answer: answer, request_type: "POST", type: type, action: "Create"})
    if type == "Answer"
      $(button).closest(".answer-actions").append(template)
    else if type == "Question"
      $(button).closest(".question-action").append(template)


submitForm = (form)->
  submit_button = $(form).find(".submit-comment")
  request_type = $(submit_button).data("request-type")
  comment = $(submit_button).data("comment")
  text_field = $(form).find(".comment-text")
  type = $(submit_button).data("type")
  question = $(submit_button).data("question")

  if type == "Answer"
    answer = $(submit_button).data("answer")
    url = "/questions/#{question}/answers/#{answer}/comments"
  else if type == "Question"
    url = "/questions/#{question}/comments"
  if comment
    url += "/#{comment}"

  $.ajax url,
    type: request_type
    data: {comment: {text: $(text_field).val()}, type: type}
    success: (response, request) ->
    error: (error) ->
      object = JSON.parse(error.responseText)
      $(".comment-form textarea").addClass("error")
      $(".comment-form textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")


removeCommentForm = (button) ->
  $(button).closest(".comment-form").hide()
  comment_id = $(button).prev(".submit-comment").data("comment")
  $.each($(".comment-item"), (key, value) ->
    if $(value).data("comment") == comment_id
      $(value).show()
  )

removeComment = (button) ->
  type = $(button).data("type")
  question = $(button).data("question")
  comment = $(button).data("comment")
  if type == "Answer"
    answer = $(button).data("answer")
    url = "/questions/#{question}/answers/#{answer}/comments/#{comment}"
  else if type == "Question"
    url = "/questions/#{question}/comments/#{comment}"

  console.log url

  $.ajax url,
    type: "DELETE"
    success: ->
      $(button).closest(".comment-item").fadeOut('slow')



editComment = (button)->
  type = $(button).data("type")
  comment = $(button).data("comment")
  text = $(button).closest(".comment-item").find(".comment-text").text().trim()
  if $(".comment-form").length > 0 || $(".answer-form.row").length > 0
    $(".comment-form").remove()
    $(".answer-form.row").remove()
  else
    if type == "Answer"
      question = $(button).data("question")
      answer = $(button).data("answer")
    else if type == "Question"
      question = $(button).data("question")
    template = JST["templates/comment_form"](form: {question: question, answer: answer, action: "Update", type: type, comment: comment, text: text, request_type: "PUT", cancel: true})
    $(button).closest(".comment-item").hide()
    $(button).closest(".comment-item").after template