$ ->
  $(document).on 'focus', 'input.attribute_name_search', (e) ->
    $(e.target).autocomplete
      source: (request, response) ->
        $.post $(e.target).data('source'), {key_cont: $.trim(request.term)}, (data) ->
          response data
          return
        return
      minLength: 2

  $(document).on 'focus', 'input.attribute_value_search', (e) ->
    $(e.target).autocomplete
      source: (request, response) ->
        $.post $(e.target).data('source'), {key_eq: $(e.target).closest('tr').find('[name*="[key]"]').val(), value_cont: $.trim(request.term)}, (data) ->
          response data
          return
        return
      minLength: 2