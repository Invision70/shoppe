$ ->
  permalink = (string, separator = '-') ->
    string = $.trim string
    string = string.replace /[^a-zA-Z0-9]/g, separator
    string = string.replace new RegExp('\\' + separator + '{2,}', 'gmi'), separator
    string = string.replace new RegExp('(^' + separator + ')|(' + separator + '$)', 'gmi'), ''
    string.toLowerCase()

  $(document).on 'change paste keyup', 'input[data-permalink]', ->
    $('#'+$(this).data 'permalink').val permalink($(this).val())

  return