$ ->
  $(".add-comment").click ->
   type = $(this).data("type")
   if $(".comment-form").length > 0 || $(".answer-form.row").length > 0
     $(".comment-form").remove()
     $(".answer-form.row").remove()
   else
     if type == "Answer"
       question = $(this).data("question")
       answer = $(this).data("answer")
       url = "/questions/#{question}/answers/#{answer}/comments/new"
     else if type == "Question"
       question = $(this).data("question")
       url = "/questions/#{question}/comments/new"


     $.ajax url,
       type: "GET"
       data: {type: type}
       success: (html) ->
         if type == "Answer"
           $(".answer-actions").append(html)
         else if type == "Question"
           $(".question-action").append(html)

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
#  question = $(".answers-list").data("question")
#  PrivatePub.subscribe "/questions/#{question}/comments", (data, channel) ->
#    comment = $.parseJSON(data['comment'])
#    $(".comments-list").prepend JST["templates/comment"](comment: comment)
#    $(".comment-form").remove()
#
#  PrivatePub.subscribe "/questions/#{question}/comments/edit", (data, channel) ->
#    comment = $.parseJSON(data['comment'])
#    $.each($(".comment-item"), (key, value) ->
#      if comment.id == $(value).data("comment")
#        $(".comment-form").remove()
#        $(value).fadeOut('slow').replaceWith(JST["templates/comment"](comment: comment)).fadeIn('slow')
#    )
#
$(document).delegate(".comment-form", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  $(".comment-form textarea").removeClass("error")
  $(".error-text").remove()
  type = $(this).data("type")
#  question = $(".comment-form .submit-comment").data("question")
  form = $(".comment-form")
  url = form.attr("action")
  console.log form.serialize()
  $.ajax url,
    type: "POST"
    data: form.serialize()
    success: (data)->
    error: (error) ->
      object = JSON.parse(error.responseText)
      $(".comment-form textarea").addClass("error")
      $(".comment-form textarea").parent().append("<div class='error-text'>#{object.text[0]}</div>")
)
