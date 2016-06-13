import Timer
import Tasklist

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
  { clock : Timer.Model
  , list : Tasklist.Model
  }

init : (Model, Cmd Msg)
init =
  let
    (clockModel, clockFx) =
      Timer.init

    (listModel, listFx) =
      Tasklist.init
  in
    ( Model clockModel listModel
    , Cmd.batch
      [ Cmd.map Clock clockFx
      , Cmd.map Tasks listFx
      ]
    )

-- update

type Msg
  = Clock Timer.Msg
  | Tasks Tasklist.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Clock msg ->
      let
        (clock, clockCmds) =
          Timer.update msg model.clock
      in
        ({ model | clock = clock }
        , Cmd.map Clock clockCmds
        )

    Tasks msg ->
      let
        (list, listCmds) =
          Tasklist.update msg model.list
      in
        ({ model | list = list }
        , Cmd.map Tasks listCmds
        )

-- subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map Clock (Timer.subscriptions model.clock)

-- view

view : Model -> Html Msg
view model =
  div []
    [ Html.map Clock (Timer.view model.clock)
    , Html.map Tasks (Tasklist.view model.list)
    ]
