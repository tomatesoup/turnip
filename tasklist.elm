module Tasklist exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App as Html

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

--model

type alias Model =
  { task: String
  , tasks: List String
  }

init : (Model, Cmd Msg)
init =
  ({ task = "", tasks = [] }, Cmd.none)

--update

type Msg
  = UpdateText String
  | AddItem
  | RemoveItem String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateText text ->
      ({ model | task = text }, Cmd.none)

    AddItem ->
      ({ model | task = "", tasks = model.task :: model.tasks }, Cmd.none)

    RemoveItem task ->
      ({ model | tasks = List.filter (\t -> t /= task) model.tasks }, Cmd.none)

-- subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

--view

taskItem task =
  li []
    [ text task
    , button [ onClick (RemoveItem task) ] [text "X"]
    ]

tasksList tasks =
  let
    children = List.map taskItem tasks
  in
    ul [] children

view : Model -> Html Msg

view model =
  div []
    [ h1 [] [ text "Task List" ]
    ,input [ type' "text"
            , onInput UpdateText
            , value model.task
            ] []
    , button [ onClick AddItem ] [ text "Add task" ]
    , tasksList model.tasks
    ]
