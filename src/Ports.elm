port module Ports exposing (..)

import Json.Decode exposing (Value)
import Models exposing (Options)


port updateGameData : (Value -> msg) -> Sub msg


port saveOptions : Options -> Cmd msg


port toggleGatherCatnip : () -> Cmd msg


port toggleObserveSky : () -> Cmd msg


port sendHunters : () -> Cmd msg


port praiseSun : () -> Cmd msg


port buildField : () -> Cmd msg


port buildHut : () -> Cmd msg


port buildBarn : () -> Cmd msg


port craftWood : () -> Cmd msg
