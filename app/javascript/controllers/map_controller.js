import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["map", "total"];
  static values = {
    key: String,
    mapData: String,
    startMark: String,
    endMark: String,
    personStartMark: String,
    personEndMark: String,
  };

  connect() {
    this.#initializeMap();
  }

  #initializeMap() {
    console.log(this);
    const data = JSON.parse(this.mapDataValue);
    const map = tt.map({
      key: this.keyValue,
      container: this.mapTarget.id,
      center: [data.user.destination.longitude, data.user.destination.latitude],
      zoom: 8,
    });

    this.#drawRoute(map, data);

    this.#createMarker(
      [data.user.origin.longitude, data.user.origin.latitude],
      this.#createPopup(`<p>${data.user.origin.city}</p>`, null, map),
      map,
      this.personStartMarkValue
    );
    this.#createMarker(
      [data.user.destination.longitude, data.user.destination.latitude],
      this.#createPopup(`<p >${data.user.destination.city}</p>`, null, map),
      map,
      this.personEndMarkValue
    );
    if (
      data.ride.origin.longitude != data.user.destination.longitude &&
      data.ride.origin.latitude != data.user.destination.latitude
    ) {
      this.#createMarker(
        [data.ride.origin.longitude, data.ride.origin.latitude],
        this.#createPopup(`<p>${data.ride.origin.city}</p>`, null, map),
        map,
        this.startMarkValue
      );
    }

    this.#createMarker(
      [data.ride.destination.longitude, data.ride.destination.latitude],
      this.#createPopup(`<p>${data.ride.destination.city}</p>`, null, map),
      map,
      this.endMarkValue
    );
  }

  #drawRoute(map, data) {
    const routeWeight = 9;
    const routeBackgroundWeight = 12;

    tt.services
      .calculateRoute({
        batchMode: "sync",
        key: this.keyValue,
        computeTravelTimeFor: "all",
        traffic: false,
        batchItems: [
          {
            locations: `${data.ride.origin.longitude},${data.ride.origin.latitude}:${data.user.origin.longitude},${data.user.origin.latitude}:${data.user.destination.longitude},${data.user.destination.latitude}:${data.ride.destination.longitude},${data.ride.destination.latitude}`,
          },
          {
            locations: `${data.user.origin.longitude},${data.user.origin.latitude}:${data.user.destination.longitude},${data.user.destination.latitude}`,
          },
        ],
      })
      .then((results) => {
        console.log(results);
        const routeRide = results.batchItems[0];
        const routeUser = results.batchItems[1];
        this.#calcutePrice(routeRide, data.ride.price_per_km);

        map
          .addLayer({
            id: "ride_background",
            type: "line",
            source: {
              type: "geojson",
              data: routeRide.toGeoJson(),
            },
            paint: {
              "line-color": "#979da2",
              "line-width": 5,
            },
            layout: {
              "line-cap": "round",
              "line-join": "round",
            },
          })
          .addLayer({
            id: "user_background",
            type: "line",
            source: {
              type: "geojson",
              data: routeUser.toGeoJson(),
            },
            paint: {
              "line-color": "#1291A8",
              "line-width": 6,
            },
            layout: {
              "line-cap": "round",
              "line-join": "round",
            },
          });
        this.#createPopupTimeTravel(routeUser, map);
      });
  }

  #createPopup(popupHTML, coordinates, map) {
    const markerHeight = 50,
      markerRadius = 10,
      linearOffset = 25;

    const popupOffsets = {
      top: [0, 0],
      "top-left": [0, 0],
      "top-right": [0, 0],
      bottom: [0, -markerHeight],
      "bottom-left": [
        linearOffset,
        (markerHeight - markerRadius + linearOffset) * -1,
      ],
      "bottom-right": [
        -linearOffset,
        (markerHeight - markerRadius + linearOffset) * -1,
      ],
      left: [markerRadius, (markerHeight - markerRadius) * -1],
      right: [-markerRadius, (markerHeight - markerRadius) * -1],
    };

    const popup = new tt.Popup({
      offset: popupOffsets,
      className: "map-popup",
      closeButton: false,
      closeOnClick: false,
    });
    if (coordinates) {
      popup.setLngLat(coordinates);
    }
    popup.setHTML(popupHTML).addTo(map);
    return popup;
  }

  #createPopupTimeTravel(routeUser, map) {
    const coordinates = routeUser.toGeoJson().features[0].geometry.coordinates;
    const midIndex = Math.floor(coordinates.length / 2);
    const userRouteSummary = routeUser.routes[0].summary;

    const popupHTML = `<p><strong> ${this.#convertSecToHours(
      userRouteSummary.travelTimeInSeconds
    )}</strong>  ${this.#convertMetersToKm(
      userRouteSummary.lengthInMeters
    )} km</p>`;

    this.#createPopup(popupHTML, coordinates[midIndex], map);
  }

  #createMarker(markerCoordinates, popup, map, icon) {
    const markerElement = document.createElement("div");
    markerElement.innerHTML = `<img src='${icon}' style='width: 32px; height: 45px';>`;
    return new tt.Marker({ element: markerElement })
      .setLngLat(markerCoordinates)
      .setPopup(popup)
      .addTo(map);
  }

  #calcutePrice(routeUser, price_per_km) {
    const userRouteSummary = routeUser.routes[0].summary;
    const distance = this.#convertMetersToKm(userRouteSummary.lengthInMeters);
    this.totalTarget.innerHTML = distance * price_per_km;
  }

  #convertSecToHours(totalSeconds) {
    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);

    const hDisplay = h > 0 ? h + (h == 1 ? " hr, " : " hrs, ") : "";
    const mDisplay = m > 0 ? m + " min" : "";

    return hDisplay + mDisplay;
  }

  #convertMetersToKm(totalMeters) {
    return (totalMeters / 1000).toFixed(1);
  }
}
