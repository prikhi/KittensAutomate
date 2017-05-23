module BuildingType exposing (..)

import Messages exposing (Msg(ToggleOption), OptionsMsg(..))
import Models exposing (Options, BuildingType(..))
import Ports


all : List BuildingType
all =
    [ Field, Hut, Library, Academy, Barn, Mine, Smelter, Workshop ]


toString : BuildingType -> String
toString buildingType =
    case buildingType of
        Field ->
            "Fields"

        Hut ->
            "Huts"

        Library ->
            "Libraries"

        Academy ->
            "Academies"

        Barn ->
            "Barns"

        Mine ->
            "Mines"

        Smelter ->
            "Smelters"

        Workshop ->
            "Workshop"


optionSelector : BuildingType -> (Options -> Bool)
optionSelector buildingType =
    case buildingType of
        Field ->
            .buildField

        Hut ->
            .buildHut

        Library ->
            .buildLibrary

        Academy ->
            .buildAcademy

        Barn ->
            .buildBarn

        Mine ->
            .buildMine

        Smelter ->
            .buildSmelter

        Workshop ->
            .buildWorkshop


message : BuildingType -> Msg
message buildingType =
    ToggleOption <|
        case buildingType of
            Field ->
                BuildField

            Hut ->
                BuildHut

            Library ->
                BuildLibrary

            Academy ->
                BuildAcademy

            Barn ->
                BuildBarn

            Mine ->
                BuildMine

            Smelter ->
                BuildSmelter

            Workshop ->
                BuildWorkshop


clickCommand : BuildingType -> Cmd msg
clickCommand buildingType =
    Ports.clickBuildingButton <|
        case buildingType of
            Field ->
                "Catnip field"

            Hut ->
                "Hut"

            Library ->
                "Library"

            Academy ->
                "Academy"

            Barn ->
                "Barn"

            Mine ->
                "Mine"

            Smelter ->
                "Smelter"

            Workshop ->
                "Workshop"
