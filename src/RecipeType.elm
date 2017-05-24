module RecipeType exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Options, RecipeType(..))
import Ports


all : List RecipeType
all =
    [ CraftWood, CraftBeam, CraftSlab ]


toString : RecipeType -> String
toString recipeType =
    case recipeType of
        CraftWood ->
            "Wood"

        CraftBeam ->
            "Beams"

        CraftSlab ->
            "Slabs"


optionSelector : RecipeType -> (Options -> Bool)
optionSelector recipeType =
    case recipeType of
        CraftWood ->
            .craftWood

        CraftBeam ->
            .craftBeam

        CraftSlab ->
            .craftSlab


message : RecipeType -> Msg
message recipeType =
    ToggleOption <|
        case recipeType of
            CraftWood ->
                Messages.CraftWood

            CraftBeam ->
                Messages.CraftBeam

            CraftSlab ->
                Messages.CraftSlab


clickCommand : RecipeType -> (Int -> Cmd msg)
clickCommand recipeType =
    curry Ports.craftResource <|
        case recipeType of
            CraftWood ->
                "wood"

            CraftBeam ->
                "beam"

            CraftSlab ->
                "slab"
