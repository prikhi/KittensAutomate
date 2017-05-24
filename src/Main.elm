module Main exposing (main)

import Json.Decode exposing (Value)
import Html exposing (Html, div, label, input, text)
import Html.Attributes exposing (type_, checked, style, href)
import Html.Events exposing (onClick)
import BuildingType
import Commands
import Decoders exposing (proceesGameData)
import Messages exposing (..)
import Models exposing (..)
import Ports
import RecipeType


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
    let
        cmds =
            case options of
                Nothing ->
                    Cmd.none

                Just options ->
                    initialCommands options
                        [ ( .gatherCatnip, Ports.toggleGatherCatnip )
                        , ( .observeSky, Ports.toggleObserveSky )
                        ]
                        |> Cmd.batch

        initialCommands options selectorsAndPorts =
            case selectorsAndPorts of
                [] ->
                    []

                ( selector, optionPort ) :: xs ->
                    if selector options then
                        optionPort () :: initialCommands options xs
                    else
                        initialCommands options xs
    in
        ( initialModel gameData options, cmds )


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



-- Update


updateOptions : OptionsMsg -> Options -> Options
updateOptions msg options =
    case msg of
        GatherCatnip ->
            { options | gatherCatnip = not options.gatherCatnip }

        ObserveSky ->
            { options | observeSky = not options.observeSky }

        SendHunters ->
            { options | sendHunters = not options.sendHunters }

        PraiseSun ->
            { options | praiseSun = not options.praiseSun }

        BuildField ->
            { options | buildField = not options.buildField }

        BuildHut ->
            { options | buildHut = not options.buildHut }

        BuildLogHouse ->
            { options | buildLogHouse = not options.buildLogHouse }

        BuildLibrary ->
            { options | buildLibrary = not options.buildLibrary }

        BuildAcademy ->
            { options | buildAcademy = not options.buildAcademy }

        BuildBarn ->
            { options | buildBarn = not options.buildBarn }

        BuildMine ->
            { options | buildMine = not options.buildMine }

        BuildLumberMill ->
            { options | buildLumberMill = not options.buildLumberMill }

        BuildSmelter ->
            { options | buildSmelter = not options.buildSmelter }

        BuildWorkshop ->
            { options | buildWorkshop = not options.buildWorkshop }

        BuildTradepost ->
            { options | buildTradepost = not options.buildTradepost }

        Messages.CraftWood ->
            { options | craftWood = not options.craftWood }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ options } as model) =
    case msg of
        ChangeTab newTab ->
            ( { model | currentTab = newTab }, Cmd.none )

        ToggleOption subMsg ->
            let
                updatedOptions =
                    updateOptions subMsg options

                toggleCmd =
                    case subMsg of
                        ObserveSky ->
                            Ports.toggleObserveSky ()

                        GatherCatnip ->
                            Ports.toggleGatherCatnip ()

                        _ ->
                            Cmd.none
            in
                ( { model | options = updatedOptions }
                , Cmd.batch [ Ports.saveOptions updatedOptions, toggleCmd ]
                )

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
                    [ buildOrCraftCommand
                    , Commands.sendHuntersCommand model
                    , Commands.praiseSunCommand model
                    ]
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

        buildingCheckbox buildingType =
            checkboxOption (options |> BuildingType.optionSelector buildingType)
                (BuildingType.message buildingType)
                (BuildingType.toString buildingType)

        recipeCheckbox recipeType =
            checkboxOption (options |> RecipeType.optionSelector recipeType)
                (RecipeType.message recipeType)
                (RecipeType.toString recipeType)

        currentTabContents =
            case currentTab of
                General ->
                    [ checkboxOption options.gatherCatnip (ToggleOption GatherCatnip) "Gather Catnip"
                    , checkboxOption options.observeSky (ToggleOption ObserveSky) "Observe the Sky"
                    , checkboxOption options.sendHunters (ToggleOption SendHunters) "Send Hunters"
                    , checkboxOption options.praiseSun (ToggleOption PraiseSun) "Praise the Sun"
                    ]

                Build ->
                    List.map buildingCheckbox BuildingType.all

                Craft ->
                    List.map recipeCheckbox RecipeType.all
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
