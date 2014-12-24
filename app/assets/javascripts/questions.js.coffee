$ ->
  $(".delete-question").click ->
    link = $(this).closest(".question-item")
    id = $(this).data("question")
    $.ajax "/questions/#{id}",
      type: "DELETE"
      success: ->
        link.fadeOut('slow')