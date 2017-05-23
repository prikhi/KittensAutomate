module Main exposing (main)

import Json.Decode exposing (Value)
import Html exposing (Html, div, label, input, text)
import Html.Attributes exposing (type_, checked, style, href)
import Html.Events exposing (onClick)
import Commands
import Decoders exposing (proceesGameData)
import Models exposing (Model, Options, Tab(..), initialOptions, BuildingType(..))
import Ports


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = always (Ports.updateGameData UpdateGameData)
        , view = view
        }


type alias Flags =
    { gameData : Value, options : Maybe Options }



-- Model


init : Flags -> ( Model, Cmd Msg )
init { gameData, options } =
    ( initialModel gameData options, Cmd.none )


initialModel : Value -> Maybe Options -> Model
initialModel gameData maybeOptions =
    proceesGameData
        { options = maybeOptions |> Maybe.withDefault initialOptions
        , currentTab = General
        , buildings = []
        , currentResources = []
        , recipes = []
        }
        gameData



-- Messages


type Msg
    = ChangeTab Tab
    | ToggleGatherCatnip
    | ToggleObserveSky
    | ToggleSendHunters
    | ToggleBuildField
    | ToggleBuildHut
    | ToggleBuildBarn
    | ToggleCraftWood
    | UpdateGameData Value



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ options } as model) =
    case msg of
        ChangeTab newTab ->
            ( { model | currentTab = newTab }, Cmd.none )

        ToggleGatherCatnip ->
            let
                updatedOptions =
                    { options | gatherCatnip = not options.gatherCatnip }
            in
                ( { model | options = updatedOptions }
                , Cmd.batch [ Ports.toggleGatherCatnip (), Ports.saveOptions options ]
                )

        ToggleObserveSky ->
            let
                updatedOptions =
                    { options | observeSky = not options.observeSky }
            in
                ( { model | options = updatedOptions }
                , Cmd.batch [ Ports.toggleObserveSky (), Ports.saveOptions options ]
                )

        ToggleSendHunters ->
            let
                updatedOptions =
                    { options | sendHunters = not options.sendHunters }
            in
                ( { model | options = updatedOptions }, Ports.saveOptions options )

        ToggleBuildField ->
            let
                updatedOptions =
                    { options
                        | buildField = not options.buildField
                    }
            in
                ( { model | options = updatedOptions }, Ports.saveOptions options )

        ToggleBuildHut ->
            let
                updatedOptions =
                    { options | buildHut = not options.buildHut }
            in
                ( { model | options = updatedOptions }, Ports.saveOptions options )

        ToggleBuildBarn ->
            let
                updatedOptions =
                    { options | buildBarn = not options.buildBarn }
            in
                ( { model | options = updatedOptions }, Ports.saveOptions options )

        ToggleCraftWood ->
            let
                updatedOptions =
                    { options | craftWood = not options.craftWood }
            in
                ( { model | options = updatedOptions }, Ports.saveOptions options )

        UpdateGameData jsonGameData ->
            let
                updatedModel =
                    proceesGameData model jsonGameData

                buildOrCraftCommand =
                    case Commands.getBuildCommand updatedModel of
                        Just cmd ->
                            cmd

                        Nothing ->
                            Commands.getCraftCommand updatedModel
                                |> Maybe.withDefault
                                    Cmd.none
            in
                ( updatedModel
                , Cmd.batch
                    [ buildOrCraftCommand, Commands.sendHuntersCommand model ]
                )



-- View


view : Model -> Html Msg
view { options, currentTab } =
    let
        tabLinks =
            [ ( General, "General" )
            , ( Build, "Build" )
            , ( Craft, "Craft" )
            ]
                |> List.map makeTabLink
                |> List.intersperse (text " | ")

        makeTabLink ( tab, name ) =
            if currentTab == tab then
                Html.b [] [ text name ]
            else
                Html.a [ onClick (ChangeTab tab), href "#" ] [ text name ]

        currentTabContents =
            case currentTab of
                General ->
                    [ checkboxOption options.gatherCatnip ToggleGatherCatnip "Gather Catnip"
                    , checkboxOption options.observeSky ToggleObserveSky "Observe the Sky"
                    , checkboxOption options.sendHunters ToggleSendHunters "Send Hunters"
                    ]

                Build ->
                    [ checkboxOption options.buildField ToggleBuildField "Build Fields"
                    , checkboxOption options.buildHut ToggleBuildHut "Build Huts"
                    , checkboxOption options.buildBarn ToggleBuildBarn "Build Barns"
                    ]

                Craft ->
                    [ checkboxOption options.craftWood ToggleCraftWood "Craft Wood"
                    ]
    in
        div [ style [ ( "margin", "15px 5px" ), ( "padding", "10px 5px" ), ( "border", "solid 1px black" ) ] ]
            [ Html.h3
                [ style
                    [ ( "margin", "0 0 10px" )
                    , ( "text-align", "center" )
                    ]
                ]
                [ text "Kittens Automate" ]
            , div
                [ style
                    [ ( "margin-bottom", "10px" )
                    , ( "text-align", "center" )
                    ]
                ]
                tabLinks
            , div [] <| currentTabContents
            ]


checkboxOption : Bool -> msg -> String -> Html msg
checkboxOption value msg content =
    label [ style [ ( "display", "block" ) ] ]
        [ input
            [ type_ "checkbox"
            , checked value
            , style [ ( "display", "inline-block" ) ]
            , onClick msg
            ]
            []
        , text content
        ]
