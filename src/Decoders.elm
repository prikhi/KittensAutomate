module Decoders exposing (proceesGameData)

import Json.Decode as Decode exposing (succeed)
import Models exposing (..)


proceesGameData : Model -> Decode.Value -> Model
proceesGameData model gameData =
    let
        decodeResult =
            decodeGameData gameData
    in
        case decodeResult of
            Err error ->
                Debug.crash <| "Failed to Decode Game Data " ++ error

            Ok { currentResources, buildings, recipes, hutPriceReduction, priceReduction } ->
                { model
                    | buildings = List.filterMap (\x -> x) buildings
                    , currentResources = List.filterMap (\x -> x) currentResources
                    , recipes = List.filterMap (\x -> x) recipes
                    , hutPriceReduction = hutPriceReduction
                    , priceReduction = priceReduction
                }


type alias GameData =
    { currentResources : List (Maybe CurrentResource)
    , buildings : List (Maybe Building)
    , recipes : List (Maybe Recipe)
    , hutPriceReduction : Float
    , priceReduction : Float
    }


decodeGameData : Decode.Value -> Result String GameData
decodeGameData =
    Decode.decodeValue gameDataDecoder


gameDataDecoder : Decode.Decoder GameData
gameDataDecoder =
    Decode.map5 GameData
        (Decode.field "resPool" <|
            Decode.field "resources" <|
                Decode.list (Decode.maybe currentResourceDecoder)
        )
        (Decode.field "bld" <|
            Decode.field "meta" <|
                Decode.index 0 <|
                    Decode.field "meta" <|
                        Decode.list (Decode.maybe buildingDecoder)
        )
        (Decode.field "workshop" <|
            Decode.field "crafts" <|
                Decode.list <|
                    Decode.maybe recipeDecoder
        )
        (Decode.at [ "globalEffectsCached", "hutPriceRatio" ] Decode.float)
        (Decode.at [ "globalEffectsCached", "priceRatio" ] Decode.float)


buildingTypeDecoder : Decode.Decoder BuildingType
buildingTypeDecoder =
    let
        parseBuildingType str =
            case str of
                "field" ->
                    succeed Field

                "hut" ->
                    succeed Hut

                "logHouse" ->
                    succeed LogHouse

                "library" ->
                    succeed Library

                "academy" ->
                    succeed Academy

                "barn" ->
                    succeed Barn

                "mine" ->
                    succeed Mine

                "lumberMill" ->
                    succeed LumberMill

                "smelter" ->
                    succeed Smelter

                "workshop" ->
                    succeed Workshop

                "tradepost" ->
                    succeed Tradepost

                _ ->
                    Decode.fail ("Could not decode building type: " ++ str)
    in
        Decode.string |> Decode.andThen parseBuildingType


buildingDecoder : Decode.Decoder Building
buildingDecoder =
    Decode.map5 Building
        (Decode.field "name" buildingTypeDecoder)
        (Decode.field "unlocked" Decode.bool)
        (Decode.field "val" Decode.int)
        (Decode.field "priceRatio" Decode.float)
        (Decode.field "prices" (Decode.list priceDecoder))


resourceTypeDecoder : Decode.Decoder ResourceType
resourceTypeDecoder =
    let
        parseResourceType str =
            case str of
                "catnip" ->
                    succeed Catnip

                "wood" ->
                    succeed Wood

                "minerals" ->
                    succeed Minerals

                "coal" ->
                    succeed Coal

                "iron" ->
                    succeed Iron

                "gold" ->
                    succeed Gold

                "uranium" ->
                    succeed Uranium

                "oil" ->
                    succeed Oil

                "manpower" ->
                    succeed Catpower

                "science" ->
                    succeed Science

                "culture" ->
                    succeed Culture

                "faith" ->
                    succeed Faith

                "furs" ->
                    succeed Furs

                "parchment" ->
                    succeed Parchment

                "manuscript" ->
                    succeed Manuscript

                "compedium" ->
                    succeed Compendium

                _ ->
                    Decode.fail ("Could not decode resource type: " ++ str)
    in
        Decode.string |> Decode.andThen parseResourceType


priceDecoder : Decode.Decoder Price
priceDecoder =
    Decode.map2 Price
        (Decode.field "name" resourceTypeDecoder)
        (Decode.field "val" Decode.float)


currentResourceDecoder : Decode.Decoder CurrentResource
currentResourceDecoder =
    Decode.map3 CurrentResource
        (Decode.field "name" resourceTypeDecoder)
        (Decode.field "value" Decode.float)
        (Decode.field "maxValue" Decode.float)


recipeDecoder : Decode.Decoder Recipe
recipeDecoder =
    Decode.map3 Recipe
        (Decode.field "name" recipeTypeDecoder)
        (Decode.field "unlocked" Decode.bool)
        (Decode.field "prices" (Decode.list priceDecoder))


recipeTypeDecoder : Decode.Decoder RecipeType
recipeTypeDecoder =
    let
        parseRecipeType str =
            case str of
                "wood" ->
                    succeed CraftWood

                "beam" ->
                    succeed CraftBeam

                "slab" ->
                    succeed CraftSlab

                "plate" ->
                    succeed CraftPlate

                "steel" ->
                    succeed CraftSteel

                "kerosene" ->
                    succeed CraftKerosene

                "parchment" ->
                    succeed CraftParchment

                "manuscript" ->
                    succeed CraftManuscript

                "compedium" ->
                    succeed CraftCompendium

                "thorium" ->
                    succeed CraftThorium

                _ ->
                    Decode.fail ("Could not decode recipe type: " ++ str)
    in
        Decode.string |> Decode.andThen parseRecipeType
