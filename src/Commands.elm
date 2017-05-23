module Commands exposing (buildFieldCommand, craftWoodCommand)

import Models exposing (Model, Options, CurrentResource, Price, BuildingType(..), RecipeType(..))
import Ports


buildFieldCommand : Model -> Cmd msg
buildFieldCommand =
    buildCommand Field .buildField Ports.buildField


craftWoodCommand : Model -> Cmd msg
craftWoodCommand =
    craftCommand Wood .craftWood Ports.craftWood


buildCommand : BuildingType -> (Options -> Bool) -> (() -> Cmd msg) -> Model -> Cmd msg
buildCommand =
    buildCraftCommand .buildingType
        .buildings
        (\i p -> { p | amount = i.priceRatio ^ (toFloat i.count) * p.amount })


craftCommand : RecipeType -> (Options -> Bool) -> (() -> Cmd msg) -> Model -> Cmd msg
craftCommand =
    buildCraftCommand .recipeType .recipes (flip always)


buildCraftCommand :
    ({ a | prices : List Price, unlocked : Bool } -> b)
    -> (Model -> List { a | prices : List Price, unlocked : Bool })
    -> ({ a | prices : List Price, unlocked : Bool } -> Price -> Price)
    -> b
    -> (Options -> Bool)
    -> (() -> Cmd msg)
    -> Model
    -> Cmd msg
buildCraftCommand typeSelector modelSelector priceFunc desiredType optionsSelector cmd ({ options, currentResources } as model) =
    let
        enabled =
            optionsSelector options && unlocked

        maybeItem =
            List.filter (\i -> typeSelector i == desiredType) (modelSelector model) |> List.head

        unlocked =
            maybeItem |> Maybe.map (.unlocked) |> Maybe.withDefault False

        prices =
            maybeItem
                |> Maybe.map (\i -> List.map (priceFunc i) i.prices)
                |> Maybe.withDefault []

        canAfford =
            List.length prices > 0 && List.all (enoughResources currentResources) prices
    in
        if enabled && canAfford then
            cmd ()
        else
            Cmd.none


enoughResources : List CurrentResource -> Price -> Bool
enoughResources currentResources { resourceType, amount } =
    List.filter (\r -> r.resourceType == resourceType) currentResources
        |> List.head
        |> Maybe.map (\r -> r.current > amount && r.current / r.max > 0.9)
        |> Maybe.withDefault False
