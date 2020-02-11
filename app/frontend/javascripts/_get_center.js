function getFromCenter() {
  if (checkSerchForm()) {
    let latlng = map.getCenter();
    deleteMarkerLocation();
    deleteMarkers(markerNum);
    markerLocation = new google.maps.Marker({
      map: map,
      animation: google.maps.Animation.DROP,
      position: latlng
    });
    fetchApi(latlng.lat(), latlng.lng());
  }
}

$(document).on("touchend click", "#get_center_btn", function() {
  event.preventDefault();
  getFromCenter();
});
