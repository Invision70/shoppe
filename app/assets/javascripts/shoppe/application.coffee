#= require jquery
#= require jquery_ujs
#= require wice_grid
#= require shoppe/mousetrap
#= require shoppe/jquery_ui
#= require shoppe/jquery_ui_timepicker
#= require shoppe/chosen.jquery
#= require nifty/dialog
#= require jquery.ui.nestedSortable
#= require sortable_tree/initializer
#= require jstree
#= require shoppe/permalink
#= require shoppe/order_form

$ ->

  permalink = (string, separator = '-') ->
    string = $.trim string
    string = string.replace /[^a-zA-Z0-9]/g, separator
    string = string.replace new RegExp('\\' + separator + '{2,}', 'gmi'), separator
    string = string.replace new RegExp('(^' + separator + ')|(' + separator + '$)', 'gmi'), ''
    string.toLowerCase()

  $('.datepicker').datepicker
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true
    showButtonPanel: true

  $('.datetimepicker').datetimepicker
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true
    showButtonPanel: true

  # Autocomplete input.autocomplete[data-source="route_path_here"]
  $(document).on 'focus', 'input.autocomplete', (e) ->
    $(e.target).autocomplete
      source: (request, response) ->
        $.post $(e.target).data('source'), { query: request.term }, (data) ->
          response data
          return
        return
      minLength: 2

  # Attribute for variants
  $('.variantInfo .type select').on 'change', ->
    $('.variantInfo .name dd .item').hide()
    if $(this).val()
      item = $('.variantInfo .name dd .item[data-type="'+$(this).val()+'"]')
      item.find('select').chosen({width: '100%'})
      item.show()
      $('#product_name').val(item.find('select').val()).change()
    else
      $('.variantInfo .name dd .item.custom').show()
  .change()

  $('.variantInfo #product_name').on 'change', ->
    $('#product_permalink').val(permalink $(this).val())
    $('#product_sku').val(permalink $(this).val())

  $('.variantInfo [name="setter_product_name"]').on 'change paste keyup keypress', ->
    $('#product_name').val($(this).val()).change()

  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()

  # When clicking the customer search button, toggle the form
  $('a[rel=searchCustomers]').on 'click', ->
    $('div.customerSearch').toggle()
  
  # Add a new attribute to a table
  $('a[data-behavior=addAttributeToAttributesTable]').on 'click', ->
    table = $('table.productAttributes')
    if $('tbody tr', table).length == 1 || $('tbody tr:last td:first input', table).val().length > 0
      template = $('tr.template', table).html()
      table.append("<tr>#{template}</tr>")
    false
  
  # Remove an attribute from a table
  $('table.productAttributes:not(.manage) tbody').not('.manage').on 'click', 'tr td.remove a', ->
    $(this).parents('tr').remove()
    false
  # Remove an attribute from a manage table
  $('table.productAttributes.manage tbody').on 'click', 'tr td.remove a', ->
    $(this).parents('tr').hide();
    $(this).parent().append($('<input>').attr({
      type: 'hidden',
      name: 'product_attributes_array[][remove]',
      value: 1
    }))
    false
  
  # Sorting on the product attribtues table
  $('table.productAttributes tbody').sortable
    axis: 'y'
    handle: '.handle'
    cursor: 'move',
    helper: (e,tr)->
      originals = tr.children()
      helper = tr.clone()
      helper.children().each (index)->
        $(this).width(originals.eq(index).width())
      helper

  $('a[data-behavior=addAttachmentToExtraAttachments]').on 'click', (event) ->
    event.preventDefault();
    $('div.extraAttachments').show();
    $(this).hide();
  
  # Chosen
  $('select.chosen').chosen()
  $('select.chosen-with-deselect').chosen({allow_single_deselect: true})
  $('select.chosen-basic').chosen({disable_search_threshold:100})
  
  # Printables
  $('a[rel=print]').on 'click', ->
    window.open($(this).attr('href'), 'despatchnote', 'width=700,height=800')
    false
    
  # Close dialog
  $('body').on 'click', 'a[rel=closeDialog]', Nifty.Dialog.closeTopDialog
  
  # Open AJAX dialogs
  $('a[rel=dialog]').on 'click', ->
    element = $(this)
    options = {}
    options.width = element.data('dialog-width') if element.data('dialog-width')
    options.offset = element.data('dialog-offset') if element.data('dialog-offset')
    options.behavior = element.data('dialog-behavior') if element.data('dialog-behavior')
    options.id = 'ajax'
    options.url = element.attr('href')
    Nifty.Dialog.open(options)
    false
  
  # Format money values to 2 decimal places
  $('div.moneyInput input').each formatMoneyField
  $('body').on('blur', 'div.moneyInput input', formatMoneyField)

#
# Format money values to 2 decimal places
#
window.formatMoneyField = ->
  value = $(this).val().replace /,/, ""
  $(this).val(parseFloat(value).toFixed(2)) if value.length

#
# Stock Level Adjustment dialog beavior
#
Nifty.Dialog.addBehavior
  name: 'stockLevelAdjustments'
  onLoad: (dialog,options)->
    $('input[type=text]:first', dialog).focus()
    $(dialog).on 'submit', 'form', ->
      form = $(this)
      $.ajax
        url: form.attr('action')
        method: 'POST'
        data: form.serialize()
        dataType: 'text'
        success: (data)->
          $('div.table', dialog).replaceWith(data)
          $('input[type=text]:first', dialog).focus()
        error: (xhr)->
          if xhr.status == 422
            alert xhr.responseText
          else
            alert 'An error occurred while saving the stock level.'
      false
    $(dialog).on 'click', 'nav.pagination a', ->
      $.ajax
        url: $(this).attr('href')
        success: (data)->
          $('div.table', dialog).replaceWith(data)
      false

#
# Product category edit dialog beavior
#

Nifty.Dialog.addBehavior
  name: 'itemCategoryEdit'
  beforeLoad: (el,options)->
    if selected_category = $.param($('.category_ids input').serializeArray())
      options['url'] = options['url']+'?'+selected_category
  onClose: ->
    selected_category = $("#product_category_tree").jstree("get_checked", null, true).map (value) ->
      $('<input>').attr({'type': 'hidden', 'name': 'product[product_category_ids][]'}).val(value)
    $('.category_ids').empty().append(selected_category)

#
# Always fire keyboard shortcuts when focused on fields
#
Mousetrap.stopCallback = -> false

#
# Close dialogs on escape
#
Mousetrap.bind 'escape', ->
  Nifty.Dialog.closeTopDialog()
  false
  
