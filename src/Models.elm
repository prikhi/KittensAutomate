module Models exposing (..)


type alias Model =
    { options : Options
    , currentResources : List CurrentResource
    , buildings : List Building
    }


type alias Options =
    { gatherCatnip : Bool
    , buildField : Bool
    }


initialOptions : Options
initialOptions =
    { gatherCatnip = False
    , buildField = False
    }


type BuildingType
    = Field


type alias Building =
    { buildingType : BuildingType
    , unlocked : Bool
    , count : Int
    , prices : List Price
    }


type ResourceType
    = Catnip


type alias Price =
    { resourceType : ResourceType
    , amount : Float
    }


type alias CurrentResource =
    { resourceType : ResourceType
    , current : Float
    , max : Float
    }
