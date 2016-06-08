import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App as Html

main =
  Html.beginnerProgram
    { model = model
    , update = update
    , view = view
    }

--model

type alias Model =
  { task: String
  , tasks: List String
  }

model =
  { task = ""
  , tasks = []
  }

--update

type Msg
  = UpdateText String
  | AddItem
  | RemoveItem String

update msg model =
  case msg of
    UpdateText text ->
      { model | task = text }

    AddItem ->
      { model | task = "", tasks = model.task :: model.tasks }

    RemoveItem task ->
      { model |
        tasks =
          List.filter (\t -> t /= task) model.tasks }

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
