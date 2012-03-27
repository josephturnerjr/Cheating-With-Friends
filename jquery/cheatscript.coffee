balloonx = 0
balloony = 0

window.moveballoon =  ->
    balloonx += 1
    balloony += 1
    $('.balloon').css("top", balloony).css("left", balloonx)

onready = () ->
    $("#cheatmain").cheatwidget()
    setInterval('window.moveballoon()', 50)

$(document).ready(onready)
