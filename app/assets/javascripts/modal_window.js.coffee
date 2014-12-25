$ ->
  $(".authentication-links a").click ->
    $("#myModal .modal-body ul.nav.nav-tabs li").removeClass("active")
    $("#myModal").modal()
