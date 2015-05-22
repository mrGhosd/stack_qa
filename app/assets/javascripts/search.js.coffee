$ ->
  $(".search-text").on "keyup", ->
    console.log $(this).val()




  $(".search-control .search-link").click ->
    $(".search-item").remove()
    filter = $("#search_filter").val()
    query = $("#search").val()
    $.ajax "/search",
      type: "GET"
      data: {query: query, filter: filter}
      success: (request, response)->
        if request.length > 0
          $(".search-list").show().append(request)
        console.log request
        console.log response
      error: (request, response) ->
        console.log request
        console.log response


  $("*").click ->
    $(".search-list").hide()
    $(".search-item").remove()

