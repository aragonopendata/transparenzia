$ ->

  changeTab = (e) ->
    e.preventDefault()
    $("ul.gen-tabs li a.active").removeClass("active")
    $(this).addClass("active")
    showTabContent $(this).attr("href")

  showTabContent = (activeElem) ->
    $(".tabs-content").children().hide()
    $(activeElem).show()

  $("li a").click changeTab