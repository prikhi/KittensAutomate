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

            Ok { currentResources, buildings, recipes } ->
                { model
                    | buildings = List.filterMap (\x -> x) buildings
                    , currentResources = List.filterMap (\x -> x) currentResources
                    , recipes = List.filterMap (\x -> x) recipes
                }


type alias GameData =
    { currentResources : List (Maybe CurrentResource)
    , buildings : List (Maybe Building)
    , recipes : List (Maybe Recipe)
    }


decodeGameData : Decode.Value -> Result String GameData
decodeGameData =
    Decode.decodeValue gameDataDecoder


gameDataDecoder : Decode.Decoder GameData
gameDataDecoder =
    Decode.map3 GameData
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
        (Decode.field "craftTable" <|
            Decode.field "resRows" <|
                Decode.list <|
                    Decode.maybe (Decode.field "recipeRef" recipeDecoder)
        )


buildingTypeDecoder : Decode.Decoder BuildingType
buildingTypeDecoder =
    let
        parseBuildingType str =
            case str of
                "field" ->
                    succeed Field

                "hut" ->
                    succeed Hut

                "barn" ->
                    succeed Barn

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

                _ ->
                    Decode.fail ("Could not decode recipe type: " ++ str)
    in
        Decode.string |> Decode.andThen parseRecipeType
