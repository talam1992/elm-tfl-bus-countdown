import $ from "jquery";
import "signalr";
import "./tflHubs";

import Elm from './Main.elm'

const elmDiv = document.querySelector("#main");
const elmApp = Elm.Main.embed(elmDiv);

$.connection.hub.url = "https://push-api.tfl.gov.uk/signalr/hubs/signalr";

const hub = $.connection.predictionsRoomHub;

elmApp.ports.registerForPredictions.subscribe(function(naptanId) {
  $.connection.hub.start().done(function() {
    const lineRooms = [{ "NaptanId": naptanId }];
    hub.server.addLineRooms(lineRooms)
  });
});


// Push notification callback
hub.client.showPredictions = predictions => {
  console.log(predictions[0].Timestamp);
  const predictionStrings = predictions.sort( (a,b) => {
    if (a.TimeToStation > b.TimeToStation) return 1;
    if (a.TimeToStation < b.TimeToStation) return -1;
    return 0;
  }).map( p => {
    const dueMinutes = Math.floor(p.TimeToStation/60);
    return p.LineName + ": " + p.DestinationName + " (" + dueMinutes + " mins) [" + p.VehicleId + "]";
  });

  console.log(predictions);
  elmApp.ports.predictions.send(predictionStrings);
}
