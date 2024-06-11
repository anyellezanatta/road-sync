import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["map"];
  static values = {
    key: String,
    mapData: String,
    startMark: String,
    endMark: String,
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

    console.log(this.startMarkValue, "image");

    this.#drawRoute(map, data);

    this.#createMarker(
      [data.user.origin.longitude, data.user.origin.latitude],
      new tt.Popup({ offset: 35 }).setHTML("User start point"),
      map,
      this.startMarkValue
    );
    this.#createMarker(
      [data.user.destination.longitude, data.user.destination.latitude],
      new tt.Popup({ offset: 35 }).setHTML("User end point"),
      map,
      this.endMarkValue
    );
    if (
      data.ride.origin.longitude != data.user.destination.longitude &&
      data.ride.origin.latitude != data.user.destination.latitude
    ) {
      this.#createMarker(
        [data.ride.origin.longitude, data.ride.origin.latitude],
        new tt.Popup({ offset: 35 }).setHTML("Ride start point"),
        map,
        this.startMarkValue
      );
    }

    this.#createMarker(
      [data.ride.destination.longitude, data.ride.destination.latitude],
      new tt.Popup({ offset: 35 }).setHTML("Ride end point"),
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
        // option: [{ computeTravelTimeFor: "all" }],
        batchItems: [
          {
            locations: `${data.ride.origin.longitude},${data.ride.origin.latitude}:${data.ride.destination.longitude},${data.ride.destination.latitude}`,
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

        console.log(map);
        map
          .addLayer({
            id: "ride_background",
            type: "line",
            source: {
              type: "geojson",
              data: routeRide.toGeoJson(),
            },
            paint: {
              "line-color": "gray",
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
              "line-color": "blue",
              "line-width": 6,
            },
            layout: {
              "line-cap": "round",
              "line-join": "round",
            },
          });
        this.#createPopup(routeUser, map);
      });
  }

  #createPopup(routeUser, map) {
    const coordinates = routeUser.toGeoJson().features[0].geometry.coordinates;
    const midIndex = Math.floor(coordinates.length / 2);
    const userRouteSummary = routeUser.routes[0].summary;

    const popupHTML = `<p class="map-popup" ><strong> ${this.#convertSecToHours(
      userRouteSummary.travelTimeInSeconds
    )}</strong>  ${this.#convertMetersToKm(
      userRouteSummary.lengthInMeters
    )}</p>`;

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
    })
      .setLngLat(coordinates[midIndex])
      .setHTML(popupHTML)
      .addTo(map);
  }

  #createMarker(markerCoordinates, popup, map, icon) {
    const markerElement = document.createElement("div");
    markerElement.innerHTML = `<img src='${icon}' style='width: 32px; height: 32px';>`;
    return new tt.Marker({ element: markerElement })
      .setLngLat(markerCoordinates)
      .setPopup(popup)
      .addTo(map);
  }

  #convertSecToHours(totalSeconds) {
    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);

    const hDisplay = h > 0 ? h + (h == 1 ? " hr, " : " hrs, ") : "";
    const mDisplay = m > 0 ? m + " min" : "";

    return hDisplay + mDisplay;
  }

  #convertMetersToKm(totalMeters) {
    return (totalMeters / 1000).toFixed(1) + " km";
  }
}
