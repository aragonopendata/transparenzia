$ ->
  # $((".tabs-content").children():not(.active)).hide()
  $('[id^="pestana"]:not(.active)').hide()

  changeTab = (e) ->
    e.preventDefault()
    $("ul.tabs li a.active").removeClass("active")
    $(this).addClass("active")
    showTabContent $(this).attr("href")

  showTabContent = (activeElem) ->
    $(".tabs-content").children().hide()
    $(activeElem).show()

  $("ul.tabs li a").click changeTab