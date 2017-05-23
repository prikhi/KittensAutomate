module Commands exposing (getBuildCommand, getCraftCommand, sendHuntersCommand, praiseSunCommand)

import Models exposing (..)
import Ports


getBuildCommand : Model -> Maybe (Cmd msg)
getBuildCommand model =
    let
        commandArgs =
            [ ( Field, .buildField, Ports.buildField )
            , ( Hut, .buildHut, Ports.buildHut )
            , ( Barn, .buildBarn, Ports.buildBarn )
            ]

        commands =
            List.filterMap (\( t, opt, cmd ) -> buildCommand t opt cmd model)
                commandArgs
    in
        List.head commands


getCraftCommand : Model -> Maybe (Cmd msg)
getCraftCommand model =
    let
        commandArgs =
            [ ( CraftWood, .craftWood, Ports.craftWood )
            ]

        commands =
            List.filterMap (\( t, opt, cmd ) -> craftCommand t opt cmd model)
                commandArgs
    in
        List.head commands


sendHuntersCommand : Model -> Cmd msg
sendHuntersCommand model =
    let
        atMaxCatpower =
            List.filter (\r -> r.resourceType == Catpower) model.currentResources
                |> List.head
                |> Maybe.map (\r -> r.current >= 0.98 * r.max)
                |> Maybe.withDefault False
    in
        if model.options.sendHunters && atMaxCatpower then
            Ports.sendHunters ()
        else
            Cmd.none


praiseSunCommand : Model -> Cmd msg
praiseSunCommand model =
    let
        atMaxFaith =
            List.filter (\r -> r.resourceType == Faith) model.currentResources
                |> List.head
                |> Maybe.map (\r -> r.current >= 0.98 * r.max)
                |> Maybe.withDefault False
    in
        if model.options.praiseSun && atMaxFaith then
            Ports.praiseSun ()
        else
            Cmd.none


buildCommand : BuildingType -> (Options -> Bool) -> (() -> Cmd msg) -> Model -> Maybe (Cmd msg)
buildCommand =
    buildCraftCommand .buildingType
        .buildings
        (\i p -> { p | amount = i.priceRatio ^ (toFloat i.count) * p.amount })


craftCommand : RecipeType -> (Options -> Bool) -> (() -> Cmd msg) -> Model -> Maybe (Cmd msg)
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
    -> Maybe (Cmd msg)
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
            Just <| cmd ()
        else
            Nothing


enoughResources : List CurrentResource -> Price -> Bool
enoughResources currentResources { resourceType, amount } =
    List.filter (\r -> r.resourceType == resourceType) currentResources
        |> List.head
        |> Maybe.map (\r -> r.current > amount && r.current / r.max > 0.9)
        |> Maybe.withDefault False
