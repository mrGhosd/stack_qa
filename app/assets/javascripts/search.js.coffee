$ ->
  $(".search-control .search-link").click ->
    $(".search-item").remove()
    query = $("#search").val()
    $.ajax "/search",
      type: "GET"
      data: {query: query}
      success: (request, response)->
        $(".search-list").append(request)
        console.log request
        console.log response
      error: (request, response) ->
        console.log request
        console.log response


  $("*").click ->
   $(".search-item").remove()

