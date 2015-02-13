# DOM Address.
$ ->


  # Event populate dynamic.
  #populate municipality
  $("body").on "change",".populate_dynamic",  ->

    value = $(@).find("option:selected").val()

    $.ajax
      url: encodeURI("/address/get_municipalities/#{value}")
      dataType: "json"
      type: "POST"

      success: (info) ->
        municipality     = ""
        municipality_el  = $(".municipality_select")

        municipality += '<option value="">' + "Selecciona" + '</option>'
        $.each info, (key, val) ->
          if municipality_el.val() == val
            municipality += '<option value="' + val + '" selected="selected">' + val + '</option>'
          else
            municipality += '<option value="' + val + '">' + val + '</option>'

        $(municipality_el).html municipality

  #populate district
  $("body").on "change",".municipality_select",  ->

    value = $(@).find("option:selected").val()
    state = $(".populate_dynamic").val()

    $.ajax
      url: encodeURI("/address/get_districts/#{state}/#{value}")
      dataType: "json"
      type: "POST"

      success: (info) ->
        district     = ""
        district_el  = $(".district_select")

        district += '<option value="">' + "Selecciona" + '</option>'
        $.each info, (key, val) ->
          if district_el.val() == val
            district += '<option value="' + val + '" selected="selected">' + val + '</option>'
          else
            district += '<option value="' + val + '">' + val + '</option>'

        $(district_el).html district
