module RecipeType exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Options, RecipeType(..))
import Ports


all : List RecipeType
all =
    [ CraftWood ]


toString : RecipeType -> String
toString recipeType =
    case recipeType of
        CraftWood ->
            "Wood"


optionSelector : RecipeType -> (Options -> Bool)
optionSelector recipeType =
    case recipeType of
        CraftWood ->
            .craftWood


message : RecipeType -> Msg
message recipeType =
    ToggleOption <|
        case recipeType of
            CraftWood ->
                Messages.CraftWood


clickCommand : RecipeType -> Cmd msg
clickCommand recipeType =
    case recipeType of
        CraftWood ->
            Ports.clickBuildingButton "Refine catnip"
