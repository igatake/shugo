function codeAddress() {
  if (checkSerchForm()) {
    let inputAddress = document.getElementById("address").value;
    geocoder.geocode(
      {
        address: inputAddress
      },
      function(results, status) {
        if (status == "OK") {
          deleteMarkerLocation();
          deleteMarkers(markerNum);
          let mapLocation = results[0].geometry.location;
          map.setCenter(mapLocation);
          markerLocation = new google.maps.Marker({
            map: map,
            animation: google.maps.Animation.DROP,
            position: mapLocation
          });
          fetchApi(
            results[0].geometry.location.lat(),
            results[0].geometry.location.lng()
          );
        } else {
          alert(
            "Geocode was not successful for the following reason: " + status
          );
        }
      }
    );
  }
}

$(document).on("touchend click", "#geocode_btn", function() {
  event.preventDefault();
  codeAddress();
});

$(document).on("keydown", "#address", function(e) {
  if (e.keyCode === 13) {
    codeAddress();
  }
});
