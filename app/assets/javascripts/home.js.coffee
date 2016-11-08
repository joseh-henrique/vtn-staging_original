# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#featured_coupon").modal('show')

  number = 1 + Math.floor(Math.random() * 9)
  title = ""

  switch number
    when 1
      title = "F. Scott Fitzgerald - Tender Is The Night appraised at $19,100.00"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap2.png)"
    when 2
      title = "18 Karat gold pocket watch appraised at $12,631"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap5.png)"
    when 3
      title = "Babe Ruth Autographed Ball appraised at $32,000.00"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap4.png)"
    when 4
      title = "18k white gold ladies dinner ring appraised at $3,200"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap3.png)"
    when 5
      title = "1630 world map by Hendrik Hondius appraised at $800 "
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap9.png)"
    when 6
      title = "19th c. Chinese lacquered table appraised at $1800"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap6.png)"
    when 7
      title = "1952 Topps #261 Willie Mays appraised at $3,000"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap7.png)"
    when 8
      title = "1952 Topps #407 Eddie Mathews RC appraised at $10,000"
      $("#homeItem").css "background-image", "url(https://s3.amazonaws.com/vtn.assets.valuethisnow.com/carrousel/ap8.png)"
    when 9
      title = "Chinese Ming style Meiping form vase appraised at $3,500"
      $("#homeItem").css "background-image", "url(https://www.valuethisnow.com/assets/appraise1.png)"

  $("#theTitle").html title

  $("ul.nav li.dropdown").hover (->
    $(this).find(".dropdown-menu").stop(true, true).delay(200).fadeIn()
  ), ->
    $(this).find(".dropdown-menu").stop(true, true).delay(200).fadeOut()

  $("textarea").attr('rows',4)

  $('#new_customer').submit ->
    if $('#customer_agree_to_tos').prop('checked')
      true
    else
      alert 'You should accept the Terms and Conditions to continue'
      false

  $('#new_appraiser').submit ->
    if $('#appraiser_agree_to_provider_agreement').prop('checked')
      true
    else
      #alert 'You should agree to the Appraisal Provider Agreement to continue'
      true

  $('#new_appraiser').submit ->
    if $('#appraiser_agree_to_code_of_ethics').prop('checked')
      true
    else
      #alert 'You should agree to the Appraiser Code of Ethics to continue'
      true

$ ->
  $elem = $('#content')
  $('#nav_up').fadeIn 'slow'
  $('#nav_down').fadeIn 'slow'
  $(window).bind 'scrollstart', ->
    $('#nav_up,#nav_down').stop().animate 'opacity': '0.2'
    return
  $(window).bind 'scrollstop', ->
    $('#nav_up,#nav_down').stop().animate 'opacity': '1'
    return
  $('#nav_down').click (e) ->
    $('html, body').animate { scrollTop: $elem.height() }, 800
    return
  $('#nav_up').click (e) ->
    $('html, body').animate { scrollTop: '0px' }, 800
    return
  return

$(document).ready ->
  $('.openvideo').click ->
    $('.myvideo').toggle()
    return
  $('.report-image1').click ->
    alert("image click")
    $('.report1').toggle 1000
    iframe = document.getElementById('myIframe')[0];
    iframe.src="http://res.cloudinary.com/hpc/image/upload/c_fill,h_208,w_105/appraisal_259.png"
    $('.home-contact').show 1000
    return
  $('.report1 .close-frame').click ->
    $('.report1').hide()
    return
  $('.report-image2').click ->
    $('.report2').toggle 1000
    $('.home-contact').show 1000
    return
  $('.report2 .close-frame').click ->
    $('.report2').hide()
    return
  $('.capcha').click ->
    $('.home-contact').hide()
    return
  return

refreshIframe = ->
  ifr = document.getElementsByName('myIframe')[0]
  ifr.src = ifr.src
  return

currentSlide = undefined
rand = undefined
$(document).ready ->
  currentSlide = Math.floor(Math.random() * $('.item').length)
  rand = currentSlide
  $('#myCarousel').fadeIn 1000
  $('#myCarousel').carousel interval: 60000
  $('#myCarousel').carousel rand
  return

$(document).ready ->
#Sort random function

  random = (owlSelector) ->
    owlSelector.children().sort(->
      Math.round(Math.random()) - 0.5
    ).each ->
      $(this).appendTo owlSelector
      return
    return

  $('#owl-demo').owlCarousel
    autoPlay: 60000
    singleItem: true
    navigation: true
    navigationText: [
      '<i class=\'icon-chevron-left icon-white\'></i>'
      '<i class=\'icon-chevron-right icon-white\'></i>'
    ]
    beforeInit: (elem) ->
#Parameter elem pointing to $("#owl-demo")
      random elem
      return
  return

$(document).ready ->
  owl = $('#owl-demo')
  owl.owlCarousel
    items: 8
    itemsDesktop: [
      1100
      7
    ]
    itemsDesktopSmall: [
      900
      4
    ]
    itemsTablet: [
      600
      3
    ]
    itemsMobile: [
      375
      2
    ]
    autoPlay: true
  # Custom Navigation Events
  $('.next').click ->
    alert('in next')
    owl.trigger 'owl.next'
    return
  $('.prev').click ->
    owl.trigger 'owl.prev'
    return
  return

