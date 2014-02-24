$(document).ready ->
  $(document).on "click", "a[href*=\"#\"]", ->
    slashedHash = "#/" + @hash.slice(1)
    if @hash
      if slashedHash is location.hash
        $.smoothScroll scrollTarget: @hash
      else
        $.bbq.pushState slashedHash
      false

  $(window).bind "hashchange", (event) ->
    tgt = location.hash.replace(/^#\/?/, "")
    $.smoothScroll scrollTarget: "#" + tgt  if document.getElementById(tgt)
    return

  $(window).trigger "hashchange"
  return