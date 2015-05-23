$ ->
  $(".search-text").on "keyup", ->
    if $(this).val() == ""
      $(".search-popup").remove()
    else
      $.ajax "/search",
        type: "GET"
        data: {query: $(this).val()}
        success: (request, response)->
          $(".search-popup ul").html("")
          if $(".search-popup").length == 0
            $(".search-form").append("<div class='search-popup'><ul></ul></div>")
#          console.log request
          if request.search.length == 0
            $(".search-popup ul").append("<li class='empty-list'>#{I18n.t("share.search.empty")}</li>")
          for object in request.search.slice(0, 9)
            console.log object.question_id
            if object.question_id
              url = object.question_id
              image = "answer"
            else
              url = object.id
              image = "question"
            console.log object.text == undefined
            $(".search-popup ul").append("<li><a href=\"/questions/#{url}\" class=\"#{image}-icon\">#{object.text.substring(0, 25)}</a></li>")
        error: (request, response) ->
          console.log request
          console.log response



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

