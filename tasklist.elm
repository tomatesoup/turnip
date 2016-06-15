module Tasklist exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App as Html
import Time exposing (Time)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

--model

type alias Task =
  { description: String
  , duration: Time
  }

type alias Model =
  { input: String
  , tasks: List Task
  }

init : (Model, Cmd Msg)
init =
  ({ input = "", tasks = [] }, Cmd.none)

--update

type Msg
  = UpdateText String
  | AddItem
  | RemoveItem String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateText text ->
      ({ model | input = text }, Cmd.none)

    AddItem ->
      let
        newTask = { description = model.input , duration = 0 }
      in
        ({ model | input = "", tasks = newTask :: model.tasks }, Cmd.none)

    RemoveItem task ->
      -- Right now li's are targeted by their descr, so if two (or more) have the same descr,
      -- they will all be removed. Must add unique ID's to task items in the future.
      ({ model | tasks = List.filter (\t -> t.description /= task) model.tasks }, Cmd.none)

-- subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

--view

taskItem task =
  li []
    [ text task.description
    , button [ onClick (RemoveItem task.description) ] [text "X"]
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
            , value model.input
            ] []
    , button [ onClick AddItem ] [ text "Add task" ]
    , tasksList model.tasks
    ]
