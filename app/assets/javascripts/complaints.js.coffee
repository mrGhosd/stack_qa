$ ->
  $(".delete-complaint").click ->
    deleteComplaint($(this))







deleteComplaint = (link) ->
  complaint = $(link).data("complaint")
  $.ajax "/admin/complaints/#{complaint}",
    type: "DELETE"
    success: (response, request) ->
      $(link).closest(".complaint-item").fadeOut()