module BuildingType exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Options, BuildingType(..))
import Ports


all : List BuildingType
all =
    [ Field, Hut, Barn ]


toString : BuildingType -> String
toString buildingType =
    case buildingType of
        Field ->
            "Fields"

        Hut ->
            "Huts"

        Barn ->
            "Barns"


optionSelector : BuildingType -> (Options -> Bool)
optionSelector buildingType =
    case buildingType of
        Field ->
            .buildField

        Hut ->
            .buildHut

        Barn ->
            .buildBarn


message : BuildingType -> Msg
message buildingType =
    case buildingType of
        Field ->
            ToggleBuildField

        Hut ->
            ToggleBuildHut

        Barn ->
            ToggleBuildBarn


clickCommand : BuildingType -> Cmd msg
clickCommand buildingType =
    case buildingType of
        Field ->
            Ports.clickBuildingButton "Catnip field"

        Hut ->
            Ports.clickBuildingButton "Hut"

        Barn ->
            Ports.clickBuildingButton "Barn"
