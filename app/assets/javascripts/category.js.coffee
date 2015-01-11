$(document).delegate("category-form", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  $(".category-form input, .category-form input").removeClass("error")
  $(".error-text").remove()
  question = $(".comment-form .submit-comment").data("question")
  form = $(".comment-form")
  $.ajax "/questions/#{question}/comments",
    type: "POST"
    data: form.serialize()
    success: (data)->
      $(".comments-list").prepend JST["templates/comment"](comment: data)
      $(".comment-form").remove()
    error: (error) ->
      object = JSON.parse(error.responseText)
      $(".comment-form textarea").addClass("error")
      $(".comment-form textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)
