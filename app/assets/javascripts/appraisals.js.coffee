# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.maskMoney.min
//= require jquery.carouFredSel-6.1.0-packed
//= require jquery.fancybox-1.3.4.pack
jQuery ->
	$(".currency-input").maskMoney()
	$("#supplemental_information").collapse({toggle:false})
	$('#foo').carouFredSel({height: 380, prev : {button : "#foo_prev",key : "left"},next : {button : "#foo_next",key : "right"}});
	$("#foo a").fancybox({ autoDimensions: false, autoScale: false, width:'95%', height:'95%', cyclic: true; onStart: `function() {$("#foo").trigger("pause");}`, onClosed: `function() {$("#foo").trigger("play");}`})
	
	# Make sure that at least one image has been uploaded before continuing
	$('#btn_step_2_wizard_image_upload').click ->
		if $('.template-download').length is 0
			alert "Please upload at least one image to continue"
			false

	# An appraisal can have one default image
	set_as_default_image = (btn) ->
		$('.btn_make_image_primary').removeClass('btn-success')
		$('.btn_make_image_primary').html('<i class="icon-picture"></i> Mark as Primary')
		$(btn).addClass("btn-success")
		$(btn).addClass("btn-success").html('<i class="icon-picture icon-white"></i> Primary')

	$('#appraisal_images_table').on('click','.btn_make_image_primary', ( (event)->
		$.ajax $(this).attr("href"),
			type: 'POST'
			dataType: 'json'
			success: (data) ->
				set_as_default_image(event.target)
			error: (data) ->
				alert "Unable to set image as primary"
		false
	));

