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
    | BuildLogHouse
    | BuildLibrary
    | BuildAcademy
    | BuildBarn
    | BuildMine
    | BuildLumberMill
    | BuildSmelter
    | BuildWorkshop
    | BuildTradepost
    | CraftWood
    | CraftBeam
    | CraftSlab
