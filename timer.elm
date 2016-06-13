module Timer exposing (Model, Msg, init, update, subscriptions, view, getTime)

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
  { startTime : Time
  , elapsedTime : Time
  , isRunning : Bool
  }

init : (Model, Cmd Msg)
init =
  ({ startTime = -3600000, elapsedTime = -3600000, isRunning = False }, Cmd.none)

-- update

type Msg
  = Tick Time
  | ToggleTimer
  | ReceiveTime Time
  | Reset

getTime : Model -> Float
getTime model =
  model.elapsedTime

onError error =
  error

onSuccess time =
  ReceiveTime time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      if model.isRunning then
          ({ model | elapsedTime = (newTime - model.startTime) }, Cmd.none)
        else
          (model, Cmd.none)

    ToggleTimer ->
      if model.isRunning then
        ({ model | isRunning = False }, Cmd.none)
      else
        (model, Task.perform onError onSuccess Time.now) -- Time.now is an unpredictable ("impure") function and is wrapped in a Task, like a Promise in JS

    ReceiveTime time ->
      ({ model | startTime = time - model.elapsedTime, isRunning = True }, Cmd.none)

    Reset ->
      ({ model | startTime = -3600000, elapsedTime = -3600000, isRunning = False }, Cmd.none)

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
      [ div [] [ text ( format config "%H:%M:%S" currentDate ) ]
      , button [ onClick ToggleTimer ] [ text "start" ]
      , button [ onClick ToggleTimer ] [ text "pause/resume" ]
      , button [ onClick Reset ] [ text "reset" ]
      ]
