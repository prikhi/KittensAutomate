module Commands exposing (getBuildCommand, getCraftCommand, sendHuntersCommand, praiseSunCommand)

import Models exposing (..)
import BuildingType
import Ports
import RecipeType


getBuildCommand : Model -> Maybe (Cmd msg)
getBuildCommand model =
    let
        commands =
            List.filterMap
                (\bType ->
                    buildCommand bType
                        (BuildingType.optionSelector bType)
                        (BuildingType.clickCommand bType)
                        model
                )
                BuildingType.all
    in
        List.head commands


getCraftCommand : Model -> Maybe (Cmd msg)
getCraftCommand model =
    let
        commands =
            List.filterMap
                (\rType ->
                    craftCommand rType
                        (RecipeType.optionSelector rType)
                        (RecipeType.clickCommand rType)
                        model
                )
            <|
                List.reverse RecipeType.all
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


buildCommand : BuildingType -> (Options -> Bool) -> Cmd msg -> Model -> Maybe (Cmd msg)
buildCommand buildingType optionSelector cmd model =
    let
        priceReduction =
            if buildingType == Hut then
                model.hutPriceReduction + model.priceReduction
            else
                model.priceReduction

        hyperbolicEffect effect limit =
            let
                effect_ =
                    abs effect

                maxUndiminished =
                    0.75 * limit

                diminishedPortion =
                    effect_ - maxUndiminished

                delta =
                    0.25 * limit

                diminishedEffect =
                    (1 - (delta / (diminishedPortion + delta))) * delta

                totalEffect =
                    maxUndiminished + diminishedEffect

                totalEffect_ =
                    if effect < 0 then
                        -1 * totalEffect
                    else
                        totalEffect
            in
                if effect_ <= maxUndiminished then
                    effect
                else
                    totalEffect_

        calculatePriceRatio ratio =
            ratio + hyperbolicEffect priceReduction (ratio - 1)

        priceFunction item price =
            { price
                | amount =
                    (calculatePriceRatio item.priceRatio)
                        ^ (toFloat item.count)
                        * price.amount
            }

        shouldBuild =
            shouldBuildOrCraft .buildingType .buildings priceFunction buildingType optionSelector model
    in
        if shouldBuild then
            Just cmd
        else
            Nothing


craftCommand : RecipeType -> (Options -> Bool) -> (Int -> Cmd msg) -> Model -> Maybe (Cmd msg)
craftCommand recipeType optionSelector craftCmd ({ currentResources } as model) =
    let
        shouldCraft =
            shouldBuildOrCraft .recipeType .recipes (flip always) recipeType optionSelector model

        maybeRecipe =
            List.filter (\i -> i.recipeType == recipeType) model.recipes |> List.head

        prices =
            maybeRecipe |> Maybe.map .prices |> Maybe.withDefault []

        amountToCraft =
            List.map getCraftableAmountForResource prices
                |> List.minimum
                |> Maybe.withDefault 0

        getCraftableAmountForResource { resourceType, amount } =
            List.filter (\i -> i.resourceType == resourceType) currentResources
                |> List.head
                |> Maybe.map (\{ current } -> round (0.2 * current / amount))
                |> Maybe.withDefault 0
    in
        if shouldCraft then
            Just <| craftCmd amountToCraft
        else
            Nothing


shouldBuildOrCraft :
    ({ a | prices : List Price, unlocked : Bool } -> b)
    -> (Model -> List { a | prices : List Price, unlocked : Bool })
    -> ({ a | prices : List Price, unlocked : Bool } -> Price -> Price)
    -> b
    -> (Options -> Bool)
    -> Model
    -> Bool
shouldBuildOrCraft typeSelector modelSelector priceFunc desiredType optionsSelector ({ options, currentResources } as model) =
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
        enabled && canAfford


enoughResources : List CurrentResource -> Price -> Bool
enoughResources currentResources { resourceType, amount } =
    List.filter (\r -> r.resourceType == resourceType) currentResources
        |> List.head
        |> Maybe.map (\r -> r.current > amount && r.current / r.max > 0.9)
        |> Maybe.withDefault False
