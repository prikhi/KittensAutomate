module Main exposing (main)

import Json.Decode exposing (Value)
import Html exposing (Html, div, label, input, text)
import Html.Attributes exposing (type_, checked, style)
import Html.Events exposing (onClick)
import Commands
import Decoders exposing (proceesGameData)
import Models exposing (Model, Options, initialOptions, BuildingType(..))
import Ports


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = always (Ports.updateGameData UpdateGameData)
        , view = view
        }



-- Model


init : Value -> ( Model, Cmd Msg )
init gameData =
    ( initialModel gameData, Cmd.none )


initialModel : Value -> Model
initialModel =
    proceesGameData
        { options = initialOptions
        , buildings = []
        , currentResources = []
        , recipes = []
        }



-- Messages


type Msg
    = ToggleGatherCatnip
    | ToggleBuildField
    | ToggleCraftWood
    | UpdateGameData Value



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ options } as model) =
    case msg of
        ToggleGatherCatnip ->
            let
                updatedOptions =
                    { options | gatherCatnip = not options.gatherCatnip }
            in
                ( { model | options = updatedOptions }, Ports.toggleGatherCatnip () )

        ToggleBuildField ->
            let
                updatedOptions =
                    { options
                        | buildField = not options.buildField
                    }
            in
                ( { model | options = updatedOptions }, Cmd.none )

        ToggleCraftWood ->
            let
                updatedOptions =
                    { options | craftWood = not options.craftWood }
            in
                ( { model | options = updatedOptions }, Cmd.none )

        UpdateGameData jsonGameData ->
            let
                updatedModel =
                    proceesGameData model jsonGameData
            in
                ( updatedModel
                , Cmd.batch
                    [ Commands.buildFieldCommand updatedModel
                    , Commands.craftWoodCommand updatedModel
                    ]
                )



-- View


view : Model -> Html Msg
view { options } =
    div [ style [ ( "margin", "15px 5px" ), ( "padding", "10px 5px" ), ( "border", "solid 1px black" ) ] ]
        [ Html.h5
            [ style [ ( "margin", "0 0 10px" ), ( "text-align", "center" ) ] ]
            [ text "Kittens Automate" ]
        , checkboxOption options.gatherCatnip ToggleGatherCatnip "Gather Catnip"
        , Html.br [] []
        , checkboxOption options.buildField ToggleBuildField "Build Fields"
        , Html.br [] []
        , checkboxOption options.craftWood ToggleCraftWood "Craft Wood"
        ]


checkboxOption : Bool -> msg -> String -> Html msg
checkboxOption value msg content =
    label []
        [ input
            [ type_ "checkbox"
            , checked value
            , style [ ( "display", "inline-block" ) ]
            , onClick msg
            ]
            []
        , text content
        ]
