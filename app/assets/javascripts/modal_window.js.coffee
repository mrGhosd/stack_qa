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
