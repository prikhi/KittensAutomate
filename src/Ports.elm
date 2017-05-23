port module Ports exposing (..)

import Json.Decode exposing (Value)


port updateGameData : (Value -> msg) -> Sub msg


port toggleGatherCatnip : () -> Cmd msg


port buildField : () -> Cmd msg


port buildHut : () -> Cmd msg


port craftWood : () -> Cmd msg
