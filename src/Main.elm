module Main exposing (main)

import Html exposing (Html)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = "Hello World"
        , update = flip always
        , view = Html.text
        }


type alias Model =
    String


type Msg
    = NoOp
