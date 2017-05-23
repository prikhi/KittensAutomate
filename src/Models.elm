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
    , buildField : Bool
    , buildHut : Bool
    , craftWood : Bool
    }


initialOptions : Options
initialOptions =
    { gatherCatnip = False
    , observeSky = False
    , buildField = False
    , buildHut = False
    , craftWood = False
    }


type BuildingType
    = Field
    | Hut


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
