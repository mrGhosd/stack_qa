$ ->
  $(".widget .arrow").click ->
    changeFilter($(this))








changeFilter = (button) ->
  current_filter = button.closest(".title").data("filter")
  direction = $(button).data("direction")
  console.log current_filter + " " + direction
  $.ajax "/widget",
    type: "POST"
    data: {direction: direction, current_filter: current_filter}
    success: (response, request)->
      console.log response
      console.log request
