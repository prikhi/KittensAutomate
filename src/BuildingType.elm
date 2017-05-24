module BuildingType exposing (..)

import Messages exposing (Msg(ToggleOption), OptionsMsg(..))
import Models exposing (Options, BuildingType(..))
import Ports


all : List BuildingType
all =
    [ Field, Hut, LogHouse, Library, Academy, Barn, Mine, LumberMill, Smelter, Workshop, Tradepost ]


toString : BuildingType -> String
toString buildingType =
    case buildingType of
        Field ->
            "Fields"

        Hut ->
            "Huts"

        LogHouse ->
            "Log Houses"

        Library ->
            "Libraries"

        Academy ->
            "Academies"

        Barn ->
            "Barns"

        Mine ->
            "Mines"

        LumberMill ->
            "Lumber Mills"

        Smelter ->
            "Smelters"

        Workshop ->
            "Workshops"

        Tradepost ->
            "Tradeposts"


optionSelector : BuildingType -> (Options -> Bool)
optionSelector buildingType =
    case buildingType of
        Field ->
            .buildField

        Hut ->
            .buildHut

        LogHouse ->
            .buildLogHouse

        Library ->
            .buildLibrary

        Academy ->
            .buildAcademy

        Barn ->
            .buildBarn

        Mine ->
            .buildMine

        LumberMill ->
            .buildLumberMill

        Smelter ->
            .buildSmelter

        Workshop ->
            .buildWorkshop

        Tradepost ->
            .buildTradepost


message : BuildingType -> Msg
message buildingType =
    ToggleOption <|
        case buildingType of
            Field ->
                BuildField

            Hut ->
                BuildHut

            LogHouse ->
                BuildLogHouse

            Library ->
                BuildLibrary

            Academy ->
                BuildAcademy

            Barn ->
                BuildBarn

            Mine ->
                BuildMine

            LumberMill ->
                BuildLumberMill

            Smelter ->
                BuildSmelter

            Workshop ->
                BuildWorkshop

            Tradepost ->
                BuildTradepost


clickCommand : BuildingType -> Cmd msg
clickCommand buildingType =
    Ports.clickBuildingButton <|
        case buildingType of
            Field ->
                "Catnip field"

            Hut ->
                "Hut"

            LogHouse ->
                "Log House"

            Library ->
                "Library"

            Academy ->
                "Academy"

            Barn ->
                "Barn"

            Mine ->
                "Mine"

            LumberMill ->
                "Lumber Mill"

            Smelter ->
                "Smelter"

            Workshop ->
                "Workshop"

            Tradepost ->
                "Tradepost"
