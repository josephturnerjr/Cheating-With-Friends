addballoon = () ->
    $("<div class='balloon'></div>").appendTo("body").floatingballoon()

onready = () ->
    $("#cheatmain").cheatwidget()
    setInterval((() -> addballoon()), 3000)

$(document).ready(onready)
