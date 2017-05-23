module Models exposing (..)


type alias Model =
    { options : Options
    , currentResources : List CurrentResource
    , buildings : List Building
    , recipes : List Recipe
    }


type alias Options =
    { gatherCatnip : Bool
    , observeSky : Bool
    , sendHunters : Bool
    , buildField : Bool
    , buildHut : Bool
    , buildBarn : Bool
    , craftWood : Bool
    }


initialOptions : Options
initialOptions =
    { gatherCatnip = False
    , observeSky = False
    , sendHunters = False
    , buildField = False
    , buildHut = False
    , buildBarn = False
    , craftWood = False
    }


type BuildingType
    = Field
    | Hut
    | Barn


type alias Building =
    { buildingType : BuildingType
    , unlocked : Bool
    , count : Int
    , priceRatio : Float
    , prices : List Price
    }


type ResourceType
    = Catnip
    | Wood
    | Catpower


type alias Price =
    { resourceType : ResourceType
    , amount : Float
    }


type alias CurrentResource =
    { resourceType : ResourceType
    , current : Float
    , max : Float
    }


type RecipeType
    = CraftWood


type alias Recipe =
    { recipeType : RecipeType
    , unlocked : Bool
    , prices : List Price
    }
