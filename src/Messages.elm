module Messages exposing (Msg(..))

import Json.Decode exposing (Value)
import Models exposing (Tab)


type Msg
    = ChangeTab Tab
    | ToggleGatherCatnip
    | ToggleObserveSky
    | ToggleSendHunters
    | TogglePraiseSun
    | ToggleBuildField
    | ToggleBuildHut
    | ToggleBuildBarn
    | ToggleCraftWood
    | UpdateGameData Value
