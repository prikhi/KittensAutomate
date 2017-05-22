module Commands exposing (buildFieldCommand)

import Models exposing (Model, BuildingType(..))
import Ports


buildFieldCommand : Model -> Cmd msg
buildFieldCommand { options, buildings, currentResources } =
    let
        enabled =
            options.buildField

        prices =
            List.filter (\b -> b.buildingType == Field) buildings
                |> List.head
                |> Maybe.map (.prices)
                |> Maybe.withDefault []

        canAfford =
            List.all enoughResources prices

        enoughResources { resourceType, amount } =
            List.filter (\r -> r.resourceType == resourceType) currentResources
                |> List.head
                |> Maybe.map
                    (\r ->
                        r.current > amount && r.current / r.max > 0.9
                    )
                |> Maybe.withDefault False
    in
        if enabled && canAfford then
            Ports.buildField ()
        else
            Cmd.none
