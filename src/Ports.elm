port module Ports exposing (..)

import Json.Decode exposing (Value)
import Models exposing (Options)


port updateGameData : (Value -> msg) -> Sub msg


port saveOptions : Options -> Cmd msg


port toggleGatherCatnip : () -> Cmd msg


port toggleObserveSky : () -> Cmd msg


port sendHunters : () -> Cmd msg


port praiseSun : () -> Cmd msg


port clickBuildingButton : String -> Cmd msg
