module Messages exposing (Msg(..), OptionsMsg(..))

import Json.Decode exposing (Value)
import Models exposing (Tab)


type Msg
    = ChangeTab Tab
    | ToggleOption OptionsMsg
    | UpdateGameData Value


type OptionsMsg
    = GatherCatnip
    | ObserveSky
    | SendHunters
    | PraiseSun
    | BuildField
    | BuildHut
    | BuildLibrary
    | BuildAcademy
    | BuildBarn
    | BuildMine
    | BuildSmelter
    | BuildWorkshop
    | CraftWood
