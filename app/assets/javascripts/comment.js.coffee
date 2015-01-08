$ ->
 $(".add-comment").click ->
   if $(".comment-form").length > 0 || $(".answer-form.row").length > 0
     $(".comment-form").remove()
     $(".answer-form.row").remove()
   else
     question = $(this).data("question")
     $.get "/questions/#{question}/comments/new", (html) ->
       $(".question-action").append(html)