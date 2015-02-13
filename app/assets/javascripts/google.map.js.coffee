# General DOM Ready.
$ ->

  coordinatesLat = $('#map').attr("data-address-lat")
  coordinatesLng = $('#map').attr("data-address-Lng")

  console.log coordinatesLat
  console.log coordinatesLng
  #[-103.7032306, 20.6557683]
  stockholm = new (google.maps.LatLng)(coordinatesLat, coordinatesLng)
  parliament = new (google.maps.LatLng)(coordinatesLat, coordinatesLng)
  marker = undefined
  map = undefined

  initialize = ->
    mapOptions =
      zoom: 16
      center: stockholm
    map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
    marker = new (google.maps.Marker)(
      map: map
      draggable: true
      animation: google.maps.Animation.DROP
      position: parliament)
    google.maps.event.addListener marker, 'click', toggleBounce
    return

  toggleBounce = ->
    if marker.getAnimation() != null
      marker.setAnimation null
    else
      marker.setAnimation google.maps.Animation.BOUNCE
    return

  google.maps.event.addDomListener window, 'load', initialize