module RecipeType exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Options, RecipeType(..))
import Ports


all : List RecipeType
all =
    [ CraftWood
    , CraftBeam
    , CraftSlab
    , CraftPlate
    , CraftSteel
    , CraftKerosene
    , CraftParchment
    , CraftManuscript
    , CraftCompendium
    , CraftThorium
    ]


toString : RecipeType -> String
toString recipeType =
    case recipeType of
        CraftWood ->
            "Wood"

        CraftBeam ->
            "Beams"

        CraftSlab ->
            "Slabs"

        CraftPlate ->
            "Plates"

        CraftSteel ->
            "Steel"

        CraftKerosene ->
            "Kerosene"

        CraftParchment ->
            "Parchment"

        CraftManuscript ->
            "Manuscript"

        CraftCompendium ->
            "Compendium"

        CraftThorium ->
            "Thorium"


optionSelector : RecipeType -> (Options -> Bool)
optionSelector recipeType =
    case recipeType of
        CraftWood ->
            .craftWood

        CraftBeam ->
            .craftBeam

        CraftSlab ->
            .craftSlab

        CraftPlate ->
            .craftPlate

        CraftSteel ->
            .craftSteel

        CraftKerosene ->
            .craftKerosene

        CraftParchment ->
            .craftParchment

        CraftManuscript ->
            .craftManuscript

        CraftCompendium ->
            .craftCompendium

        CraftThorium ->
            .craftThorium


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

            CraftPlate ->
                Messages.CraftPlate

            CraftSteel ->
                Messages.CraftSteel

            CraftKerosene ->
                Messages.CraftKerosene

            CraftParchment ->
                Messages.CraftParchment

            CraftManuscript ->
                Messages.CraftManuscript

            CraftCompendium ->
                Messages.CraftCompendium

            CraftThorium ->
                Messages.CraftThorium


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

            CraftPlate ->
                "plate"

            CraftSteel ->
                "steel"

            CraftKerosene ->
                "kerosene"

            CraftParchment ->
                "parchment"

            CraftManuscript ->
                "manuscript"

            CraftCompendium ->
                "compedium"

            CraftThorium ->
                "thorium"
