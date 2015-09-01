$ ->
  $(document).on 'focus', 'input.attribute_name_search', (e) ->
    $(e.target).autocomplete
      source: (request, response) ->
        $.post $(e.target).data('source'), {q: {key_cont: $.trim(request.term)}}, (data) ->
          filtred = []
          $.each data, (key, item)->
            filtred.indexOf(item[0]) == -1 && filtred.push item[0]
            return
          response filtred
          return
        return
      minLength: 2

  $(document).on 'focus', 'input.attribute_value_search', (e) ->
    $(e.target).autocomplete
      source: (request, response) ->
        $.post $(e.target).data('source'), {q: {key_eq: $(e.target).closest('tr').find('[name*="[key]"]').val(), value_cont: $.trim(request.term)}}, (data) ->
          filtred = []
          $.each data, (key, item)->
            filtred.push item[1]
            return
          response filtred
          return
        return
      minLength: 2