$ ->
  $(".delete-complaint").click ->
    deleteComplaint($(this))

  $(".delete-parent-complaint").click ->
    deleteParentComplaint($(this))







deleteComplaint = (link) ->
  complaint = $(link).data("complaint")
  $.ajax "/admin/complaints/#{complaint}",
    type: "DELETE"
    success: (response, request) ->
      $(link).closest(".complaint-item").fadeOut()


deleteParentComplaint = (link) ->
  complaint = $(link).data("complaint")
  $.ajax "/admin/complaints/#{complaint}/parent",
    type: "DELETE"
    success: (response, request) ->
      $(link).closest(".complaint-item").fadeOut()