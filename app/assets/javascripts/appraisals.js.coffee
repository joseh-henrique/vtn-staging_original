# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.maskMoney.min
//= require jquery.carouFredSel-6.1.0-packed
//= require magiczoom
//= require chosen.jquery.min
//= require jquery.textareaCounter.plugin

jQuery ->
  $(".currency-input").maskMoney()
  $("#supplemental_information").collapse({toggle:false})
  $(".chzn-select").chosen()
  $(".show_if_checked").hide();
  
  # Make sure that at least one image has been uploaded before continuing
  $('#btn_step_2_wizard_image_upload').click ->
    if $('.img-row').length is 0
      alert "Please upload at least one image to continue"
      false

  $(".isPair").click ->
    if $(this).is(':checked')
      $(".planPrice").hide()
      $(".planPairPrice").show()
    else
      $(".planPrice").show()
      $(".planPairPrice").hide()

  # An appraisal can have one default image
  set_as_default_image = (btn) ->
    $('.btn_make_image_primary').removeClass('btn-success')
    $('.btn_make_image_primary').html('<i class="icon-picture"></i> Mark as Primary')
    $(btn).addClass("btn-success")
    $(btn).addClass("btn-success").html('<i class="icon-picture icon-white"></i> Primary')

  if ($('#fileupload').length != 0)
    $('#fileupload').fileupload({formData: {iframe_redirect_to: vtn_constants.BASE_URI+'/result.html?%s', authenticity_token: $('meta[name="csrf-token"]').attr('content') }})

  $('#appraisal_images_table').on('click','.btn_make_image_primary', ( (event)->
    $.ajax $(this).attr("href"),
      type: 'POST'
      dataType: 'json'
      success: (data) ->
        set_as_default_image(event.target)
      error: (data) ->
        alert "Unable to set image as primary"
    false
  ))


  $('input[type=radio][name=appraisal_credits]').change ->
    if $("#bulk_order_selected_plan").val() == ""
      alert("Please select appraisal plan first")
      return
    amount = PAYMENT_PLAN[$("#bulk_order_selected_plan").val()-1]
    if @value == "1"
      discount = (amount*3)*.1
      $("#total_amount").val("$"+((amount*3) - discount.toFixed(2)).toFixed(2))
      $("#amount_saved").val("$"+discount.toFixed(2))
    else if @value == "2"
      discount = (amount*5)*.15
      $("#total_amount").val("$"+((amount*5) - discount.toFixed(2)).toFixed(2))
      $("#amount_saved").val("$"+discount.toFixed(2))
    else
      discount = (amount*10)*.20
      $("#total_amount").val("$"+((amount*10) - discount.toFixed(2)).toFixed(2))
      $("#amount_saved").val("$"+discount.toFixed(2))
    return



  $('#btnSaveComment').click ->
    $('#div_comment').hide()
    $('#div_saving_comment').show()
    $.ajax ('/appraisals/comment'),
      type: 'POST'
      dataType: 'json'
      data: {comment_appraisal_id: $('#comment_appraisal_id').val(), comment: {body: $('#comment_body').val()}}
      success: (data) ->
        $('#comment_list').append('<div class="well"><h5>I wrote on ' + data.created_at +  ' :  </h5>' + data.body + '</div>')
        $('#div_comment').show()
        $('#div_saving_comment').hide()
        $('#comment_body').val("")
      error: (data) ->
        alert "Unable to save comment"
        $('#div_comment').show()
        $('#div_saving_comment').hide()
    false

  $("#chkSuggestRejection").click ->
    if ($(this).attr("checked") == "checked")
      $("#btnUpdateAppraisalReply").attr("disabled", true)
      $("#btnSubmitAppraisalReply").attr("disabled", true)
      $("#btnRejectAppraisal").attr("disabled", false)
    else
      $("#btnUpdateAppraisalReply").attr("disabled", false)
      $("#btnSubmitAppraisalReply").attr("disabled", false)
      $("#btnRejectAppraisal").attr("disabled", true)

  $('#btnRejectAppraisal').click ->
    edit_form.resetForm()
    form = $('.edit_appraisal').get(0)
    $.removeData(form,'validator')
    $('#appraisal_status').val("14")
    if $("#chkSuggestRejection").is(':checked') and $("#txtRejectionReason").val().length == 0
      alert "Please enter a reason for rejecting the appraisal"
      false

  $('.full_summary').textcounter
    type: 'word'
    min: 150
    stopInputAtMaximum: false
    displayErrorText: true
    countContainerClass: "word"
    counterErrorClass: "counter-error"
    minimumErrorText: "Please add at least 150 words"
    counterText: "Word Count: "

  $('.tax_appraisal').textcounter
    type: 'word'
    min: 150
    stopInputAtMaximum: false
    displayErrorText: true
    countContainerClass: "word"
    counterErrorClass: "counter-error"
    minimumErrorText: "Please add at least 150 words"
    counterText: "Word Count: "

  $('.short_restricted').textcounter
    type: 'word'
    max: 40
    stopInputAtMaximum: false
    displayErrorText: true
    countContainerClass: "word"
    counterErrorClass: "counter-error"
    maximumErrorText: "You are not allowed more than 40 words for this appraisal type"
    counterText: "Word Count: "

  $('.long_restricted').textcounter
    type: 'word'
    min: 50
    max: 151
    stopInputAtMaximum: false
    displayErrorText: true
    countContainerClass: "word"
    counterErrorClass: "counter-error"
    minimumErrorText: "Please add at least 50 words"
    maximumErrorText: "You are not allowed more than 150 words for this appraisal type"
    counterText: "Word Count: "

  $('.auction_estimate').textcounter
    type: 'word'
    max: 21
    stopInputAtMaximum: false
    displayErrorText: true
    countContainerClass: "word"
    counterErrorClass: "counter-error"
    maximumErrorText: "You are not allowed more than 20 words for this appraisal type"
    counterText: "Word Count: "

  $('#btnUpdateAppraisalReply').click ->
    word_count = wordCount($('#appraisal_appraisal_info_appraiser_comments').val())
    if payment_selected_plan == 9 && word_count > 20
      alert("The maximum words allowed in comments field for auction estimate is 20. Please correct and submit again.")
      false
    else if payment_selected_plan == 4 && word_count < 150
      alert("You have to write at least 150 words in comments field for long full use type. Please correct and submit again.")
      false
    else if payment_selected_plan == 2 && (word_count > 150 || word_count < 50)
      alert("You have to write min 50 words and max 150 words in comments field for long restricted use type. Please correct and submit again.")
      false
    else if payment_selected_plan == 1 && word_count > 40
      alert("The maximum words allowed in comments field for short restricted use type is 40. Please correct and submit again.")
      false
    else if payment_selected_plan == 10 && word_count < 150
      alert("You have to write at least 150 words in comments field for auction estimate type. Please correct and submit again.")
      false
    else
      true
    #EAAppraisalTypeShortRestricted = 1
    #EAAppraisalTypeTaxAppraisal = 10
    #EAAppraisalTypeLongRestricted = 2
    #EAAppraisalTypeLongForSelling = 4
    #EAAppraisalTypeAuctionEstimate = 9

  wordCount = (val) ->
    wom = val.match(/\S+/g)
    if wom then wom.length else 0

  $('#btnSubmitAppraisalReply').click ->
    $('#appraisal_status').val("10")
    word_count = wordCount($('#appraisal_appraisal_info_appraiser_comments').val())
    if payment_selected_plan == 9 && word_count > 20
      alert("The maximum words allowed in comments field for auction estimate is 20. Please correct and submit again.")
      false
    else if payment_selected_plan == 4 && word_count < 150
      alert("You have to write at least 150 words in comments field for long full use type. Please correct and submit again.")
      false
    else if payment_selected_plan == 2 && (word_count > 150 || word_count < 50)
      alert("You have to write min 50 words and max 150 words in comments field for long restricted use type. Please correct and submit again.")
      false
    else if payment_selected_plan == 1 && word_count > 40
      alert("The maximum words allowed in comments field for short restricted use type is 40. Please correct and submit again.")
      false
    else if payment_selected_plan == 10 && word_count < 150
      alert("You have to write at least 150 words in comments field for auction estimate type. Please correct and submit again.")
      false
    else
      true

  # Begin Code for Plan Selection in Appraisal Wizard $("#plansel1").click ->
  $("#planprod1").click ->
    $("#planprod1").removeClass("formProdOn")
    $("#planprod1").addClass("formProdOn")
    resetSelectTxt()
    $("#planprod2").removeClass("formProdOn")
    $("#planprod3").removeClass("formProdOn")
    $("#planprod4").removeClass("formProdOn")
    $("#planprod5").removeClass("formProdOn")
    $("#check1").html "Selected"
    $("#check1").css("color", "#e76311 !important")
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeAuctionEstimate)
    $("#bulk_order_selected_plan").val(vtn_constants.EAAppraisalTypeAuctionEstimate)

  $("#planprod2").click ->
    $("#planprod2").removeClass("formProdOn")
    $("#planprod2").addClass("formProdOn")
    resetSelectTxt()
    $("#planprod1").removeClass("formProdOn")
    $("#planprod3").removeClass("formProdOn")
    $("#planprod4").removeClass("formProdOn")
    $("#planprod5").removeClass("formProdOn")
    $("#check2").html "Selected"
    $("#check2").css("color", "#e76311 !important")
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeShortRestricted)
    $("#bulk_order_selected_plan").val(vtn_constants.EAAppraisalTypeShortRestricted)

  $("#planprod3").click ->
    $("#planprod3").removeClass("formProdOn")
    $("#planprod3").addClass("formProdOn")
    resetSelectTxt()
    $("#planprod1").removeClass("formProdOn")
    $("#planprod2").removeClass("formProdOn")
    $("#planprod4").removeClass("formProdOn")
    $("#planprod5").removeClass("formProdOn")
    $("#check3").html "Selected"
    $("#check3").css("color", "#e76311 !important")
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongRestricted)
    $("#bulk_order_selected_plan").val(vtn_constants.EAAppraisalTypeLongRestricted)

  $("#planprod4").click ->
    $("#planprod4").removeClass("formProdOn")
    $("#planprod4").addClass("formProdOn")
    resetSelectTxt()
    $("#planprod1").removeClass("formProdOn")
    $("#planprod2").removeClass("formProdOn")
    $("#planprod3").removeClass("formProdOn")
    $("#planprod5").removeClass("formProdOn")
    $("#check4").html "Selected"
    $("#check4").css("color", "#e76311 !important")
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongForSelling)
    $("#bulk_order_selected_plan").val(vtn_constants.EAAppraisalTypeLongForSelling)

  $("#planprod5").click ->
    $("#planprod5").removeClass("formProdOn")
    $("#planprod5").addClass("formProdOn")
    resetSelectTxt()
    $("#planprod1").removeClass("formProdOn")
    $("#planprod2").removeClass("formProdOn")
    $("#planprod4").removeClass("formProdOn")
    $("#planprod3").removeClass("formProdOn")
    $("#check5").html "Selected"
    $("#check5").css("color", "#e76311 !important")
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeTaxAppraisal)
    $("#bulk_order_selected_plan").val(vtn_constants.EAAppraisalTypeTaxAppraisal)

  $("#plansel1").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod1").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected")
    $("#plansel1").addClass("formProdSelected")
    resetSelectTxt()
    $("#plansel1").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeShortRestricted)

  $("#small-plansel1").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod1").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected-small")
    $("#small-plansel1").addClass("formProdSelected-small")
    resetSelectTxt()
    $("#small-plansel1").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeShortRestricted)

  $("#plansel2").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod2").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected")
    $("#plansel2").addClass("formProdSelected")
    resetSelectTxt()
    $("#plansel2").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongRestricted)

  $("#small-plansel2").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod2").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected-small")
    $("#small-plansel2").addClass("formProdSelected-small")
    resetSelectTxt()
    $("#small-plansel2").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongRestricted)


  $("#plansel4").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod4").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected")
    $("#plansel4").addClass("formProdSelected")
    resetSelectTxt()
    $("#plansel4").html "Selected"
    $("#small-plansel4").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongForSelling)

  $("#small-plansel4").click ->
    $(".formProd").removeClass("formProdOn")
    $("#planprod4").addClass("formProdOn")
    $(".formProdSelect").removeClass("formProdSelected-small")
    $("#small-plansel4").addClass("formProdSelected-small")
    resetSelectTxt()
    $("#small-plansel4").html "Selected"
    $("#appraisal_selected_plan").val(vtn_constants.EAAppraisalTypeLongForSelling)

  setSelectedPlan()
  # End Code for Plan Selection in Appraisal Wizard
  $("#divRejectionReason").hide()

  $('#chkSuggestRejection').click ->
    if $(this).is(':checked')
      $("#divRejectionReason").show()
    else
      $("#divRejectionReason").hide()
      $("#txtRejectionReason").val("")

  $("#chkImportAccount").change ->
    if $(this).is(':checked')
      $("#txtCardName").val($("#current_user_name").val())
      $("#appraisal_payment_attributes_address").val($("#current_user_address_address").val())
      $("#appraisal_payment_attributes_city").val($("#current_user_address_city").val())
      $("#appraisal_payment_attributes_state").val($("#current_user_address_state").val())
      $("#appraisal_payment_attributes_zip").val($("#current_user_address_zip").val())
    else
      $("#txtCardName").val("")
      $("#appraisal_payment_attributes_address").val("")
      $("#appraisal_payment_attributes_city").val("")
      $("#appraisal_payment_attributes_state").val("")
      $("#appraisal_payment_attributes_zip").val("")
  
  $("#chkVtnPartner").change ->
    if $(this).is(":checked")
      $(".hide_if_checked").hide()
      $(".show_if_checked").show()
      disable_user_information();

      $("#appraisal_payment_attributes_vendor_token_partner").val($("#customer_vendor_token").val())

    else
      $(".show_if_checked").hide()
      $(".hide_if_checked").show()
      enable_user_information();
    return  

  $("#auto_fill").change ->
    if $(this).is(":checked")
      $("#txtCompanyName_partner").val($("#customer_name").val())
      $("#appraisal_payment_attributes_address_partner").val($("#customer_address_attributes_address").val())
      if $("#customer_address_attributes_city").val() != "" && $("#customer_address_attributes_state").val() != "" && $("#customer_address_attributes_zip").val() != ""
        city_state_postal =  $("#customer_address_attributes_city").val() + ", " + $("#customer_address_attributes_state").val() + " " +  $("#customer_address_attributes_zip").val()
      else
        city_state_postal = ""
      $("#appraisal_payment_attributes_city_state_postal_partner").val(city_state_postal)
      $("#appraisal_payment_attributes_claim_partner").val("")
      
    else
      $("#txtCompanyName_partner").val("")
      $("#appraisal_payment_attributes_address_partner").val("")
      $("#appraisal_payment_attributes_city_state_postal_partner").val("")
      $("#appraisal_payment_attributes_claim_partner").val("")
    return
  
  $("#btnBuildWizardPhoto").click ->
    if $('.img-row').length == 1
      alert "Please upload at least one image to continue"
      false
    else
      true

  $("#btnBuildWizardGeneral").click ->       
    if $("#appraisal_classification_attributes_category_id").val() is ""
      alert "Error. Please complete all required fields"
      false
    else
      true

  $("#btnSubmitSelectPlan").click ->
    $("#signupModal").modal()
    false

  $("#createAccount").click ->
    $.ajax(
      "/customers",
      type: 'POST',
      data: {
        user: {
          name: $("#first_name").val(),
          email: $("#email").val(),
          password: $("#password").val(),
          password_confirmation: $("#password").val(),
          role: "customer"
        }
      },
      success: (data) ->
        console.log("in success "+data.message)
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("in error "+textStatus+ ": " + errorThrown)
    )
    console.log("in createAccount name is "+$("#first_name").val())
    false


  $("#btnBulkOrderPayment").click ->
    if requiredFields()
      $("#paymentModal").modal('show')
      form = $(this).closest('form')
      $.ajax(
        Routes.payment_bulk_order_path(1),
        type: 'POST',
        data: $("#new_bulk_order").serializeObject(),
        success: (data) ->
          $("#paymentModalLoading").hide()
          $("#paymentModalDeclined").html(data.message)
          $("#paymentModalDeclined").show()
          if data.status is false
            $("#paymentModalFooter").show()
          else
            setTimeout (-> $("#new_bulk_order").submit()), 1000

        error: (jqXHR, textStatus, errorThrown) ->
          $("#paymentModalLoading").hide()
          $("#paymentModalDeclined").html(textStatus+ ": " + errorThrown)
          $("#paymentModalFooter").show()
      )
      false
    else
      alert "Please complete all required fields"
      return false

  $("#btnBuildWizardPayment").click ->
    if requiredFields()
      $("#paymentModal").modal('show')
      form = $(this).closest('form')
      $.ajax '/payments',
        type: 'POST',
        data: $(this).closest("form").serializeObject(),
        success: (data) ->
          $("#paymentModalLoading").hide()
          $("#paymentModalDeclined").html(data.message)
          $("#paymentModalDeclined").show()
          if data.status is false
            $("#paymentModalFooter").show()
          else
            setTimeout (-> form.submit()), 1000

        error: (jqXHR, textStatus, errorThrown) -> 
          $("#paymentModalLoading").hide()
          $("#paymentModalDeclined").html(textStatus+ ": " + errorThrown)
          $("#paymentModalFooter").show()
      false
    else
      alert "Please complete all required fields"
      return false

  $("#paymentModal").on "hide", ->
      $("#paymentModalLoading").show();
      $("#paymentModalDeclined").hide();
      $("#paymentModalFooter").hide();

  $("#tooltipAppraiserId").tooltip
    placement: "bottom"
    title: "If you would like this appraisal report to go to a specific appraiser please enter in their appraiser ID number. If you do not know their ID number please email support at: support@ValueThisNow.com or call the referring appraiser and ask them."

  $("#txtAppraisalComments").textareaCount {originalStyle: "originalDisplayInfo"}, (data) ->
    if data.words >= 100
      $("#fullSummaryHelp").hide();
    else
      $("#fullSummaryHelp").show();

  $("#save_it_btn").click ->
    alert "Your Appraisal has been saved for the next time!"

requiredFields = ->
  isValid = true
  if $("#chkVtnPartner").length > 0 && $("#chkVtnPartner")[0].checked == true
    $("[partner-required]").not(":hidden").each ->
      isValid = false if $(this).val() is ""
  else
    $("[required]").not(":hidden").each ->
      isValid = false if $(this).val() is ""
  isValid


resetSelectTxt = ->
  $("#check1").html "Select"
  $("#check2").html "Select"
  $("#check3").html "Select"
  $("#check4").html "Select"
  $("#check5").html "Select"


  $("#plansel1").html "Select"
  $("#plansel2").html "Select"
  $("#plansel4").html "Select"

  $("#small-plansel1").html "Select"
  $("#small-plansel2").html "Select"
  $("#small-plansel4").html "Select"

setSelectedPlan = ->
  if $("#appraisal_selected_plan").val()
    $("#plansel"+$("#appraisal_selected_plan").val()).trigger('click')
  else
    $("#plansel4").trigger('click')

disable_user_information = ->
  $("#chkImportAccount").attr("disabled", "disabled");
  $("[required]").attr("disabled", "disabled");

enable_user_information = ->
  $("#chkImportAccount").removeAttr("disabled");
  $("[required]").removeAttr("disabled");



$.fn.serializeObject = ->
  json = {}
  push_counters = {}
  patterns =
    validate  : /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
    key       : /[a-zA-Z0-9_]+|(?=\[\])/g,
    push      : /^$/,
    fixed     : /^\d+$/,
    named     : /^[a-zA-Z0-9_]+$/

  @build = (base, key, value) ->
    base[key] = value
    base

  @push_counter = (key) ->
    push_counters[key] = 0 if push_counters[key] is undefined
    push_counters[key]++

  $.each $(@).serializeArray(), (i, elem) =>
    return unless patterns.validate.test(elem.name)

    keys = elem.name.match patterns.key
    merge = elem.value
    reverse_key = elem.name

    while (k = keys.pop()) isnt undefined

      if patterns.push.test k 
        re = new RegExp("\\[#{k}\\]$")
        reverse_key = reverse_key.replace re, ''
        merge = @build [], @push_counter(reverse_key), merge

      else if patterns.fixed.test k 
        merge = @build [], k, merge

      else if patterns.named.test k
        merge = @build {}, k, merge

    json = $.extend true, json, merge

  return json
