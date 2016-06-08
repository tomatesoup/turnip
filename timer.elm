import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time, second)
import Html.Events exposing (onClick)
import Html.App as Html
import Task exposing (perform)
import Date exposing (Date)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Format as Format exposing (format, formatUtc, isoMsecOffsetFormat)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- model

type alias Model =
  { startTime: Time
  , elapsedTime: Time
  , running: Bool
  }

init : (Model, Cmd Msg)
init =
  ({ startTime = -3600000, elapsedTime = -3600000, running = False }, Cmd.none)

-- update

type Msg
  = Tick Time
  | StartTimer
  | ReceiveTime Time

onError error =
  error

onSuccess time =
  ReceiveTime time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      if model.running then
          ({ model | elapsedTime = (newTime - model.startTime - 3600000) }, Cmd.none)
        else
          (model, Cmd.none)

    StartTimer -> -- Time.now is an unpredictable ("impure") function and is wrapped in a Task, like a Promise in JS
      (model, Task.perform onError onSuccess Time.now)

    ReceiveTime time ->
      ({ model | startTime = time, running = True}, Cmd.none)

-- subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick

-- view

view : Model -> Html Msg

view model =
  let
    currentDate = Date.fromTime model.elapsedTime
  in
    div []
      [ div [] [ text "00:00:00" ]
      , div [] [ text ( format config "%H:%M:%S" currentDate ) ]
      , button [ onClick StartTimer ] [ text "start" ]
      ]
