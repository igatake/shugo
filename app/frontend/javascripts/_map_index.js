function geolocation() {
  if (navigator.geolocation) {
    // 現在地を取得
    navigator.geolocation.getCurrentPosition(
      // 取得成功した場合
      function(position) {
        // 緯度・経度を変数に格納
        var mapLatLng = new google.maps.LatLng(
          position.coords.latitude,
          position.coords.longitude
        );
        console.log(position.coords.latitude);
        console.log(position.coords.longitude);

        deleteMarker();
        map.setCenter(mapLatLng);

        marker = new google.maps.Marker({
          map: map,
          position: mapLatLng
        });
      },
      // 取得失敗した場合
      function(error) {
        // エラーメッセージを表示
        switch (error.code) {
          case 1: // PERMISSION_DENIED
            alert("位置情報の利用が許可されていません");
            break;
          case 2: // POSITION_UNAVAILABLE
            alert("現在位置が取得できませんでした");
            break;
          case 3: // TIMEOUT
            alert("タイムアウトになりました");
            break;
          default:
            alert("その他のエラー(エラーコード:" + error.code + ")");
            break;
        }
      }
    );
  } else {
    alert("この端末では位置情報が取得できません");
  }
}
