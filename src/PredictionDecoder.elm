module PredictionDecoder exposing (decodePredictions, predictionsDecoder, initialPredictionsDecoder)

import Json.Encode as Json
import Date
import Json.Decode exposing (decodeValue, list, int, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Prediction exposing (Prediction)
import Json.Decode.Extra exposing (date)


decodePredictions : Json.Value -> List Prediction
decodePredictions json =
    case decodeValue predictionsDecoder json of
        Ok val ->
            val

        Err msg ->
            Debug.crash msg



-- Note: The initial predictions fetch over HTTP has camel case key names with
-- lowercase first letters. The websocket stream has camelcase keys with
-- uppercase first letters :-/


predictionsDecoder : Decoder (List Prediction)
predictionsDecoder =
    list predictionDecoder


predictionDecoder : Decoder Prediction
predictionDecoder =
    decode Prediction
        |> required "LineName" string
        |> required "TimeToStation" int
        |> required "DestinationName" string
        |> required "VehicleId" string
        |> required "TimeToLive" date


initialPredictionsDecoder : Decoder (List Prediction)
initialPredictionsDecoder =
    list initialPredictionDecoder


initialPredictionDecoder : Decoder Prediction
initialPredictionDecoder =
    decode Prediction
        |> required "lineName" string
        |> required "timeToStation" int
        |> required "destinationName" string
        |> required "vehicleId" string
        |> required "timeToLive" date
