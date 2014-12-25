$ ->
  $(".authentication-links a").click ->
    $('#myModal ul.nav.nav-tabs li, #myModal .tab-content .tab-pane').removeClass('active')
    action = $(this).data("action")
    $("#myModal").find("a[href=##{action}]").parent().addClass("active")
    $("#myModal").find("##{action}.tab-pane").addClass("active")
    $("#myModal").modal()

  $('#myModal ul.nav.nav-tabs a').click (event)->
    event.preventDefault()
    $(this).tab('show')

  $("#myModal .form-delegate").click ->
    form = $("#myModal .tab-content .tab-pane.active").find("form")
    url = $(form).attr("action")
    console.log url
    console.log form.serialize()
    $.ajax url,
      type: "POST"
      data: form.serialize()
      dataType: "json"
      success: (data, textStatus, jqXHR)->
        console.log data
      error: (jqXHR, textStatus, errorThrown) ->
        console.log errorThrown
        console.log jqXHR
        console.log textStatus
