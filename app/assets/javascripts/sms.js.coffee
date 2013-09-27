# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if $('body.sms_index').length > 0 
  $('#sms_index_transfer_trigger').click ->
    $('#sms_index_transfer_panel').show()
    $('#sms_index_transfer_placeholder').hide()

  $('.department_checkbox').click ->
    department_id = parseInt(this.id.split('_')[1])
    $('.department_' + department_id + '_member').prop('checked', this.checked)
