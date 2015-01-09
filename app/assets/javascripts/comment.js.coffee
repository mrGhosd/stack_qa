$ ->
 $(".add-comment").click ->
   if $(".comment-form").length > 0 || $(".answer-form.row").length > 0
     $(".comment-form").remove()
     $(".answer-form.row").remove()
   else
     question = $(this).data("question")
     $.get "/questions/#{question}/comments/new", (html) ->
       $(".question-action").append(html)



$(document).delegate(".comment-form", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
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
      console.log object
#      $("#new_answer textarea").addClass("error")
#      $("#new_answer textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)
