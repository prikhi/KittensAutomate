module Models exposing (..)


type alias Model =
    { options : Options
    , currentTab : Tab
    , currentResources : List CurrentResource
    , buildings : List Building
    , recipes : List Recipe
    }


type alias Options =
    { gatherCatnip : Bool
    , observeSky : Bool
    , sendHunters : Bool
    , praiseSun : Bool
    , buildField : Bool
    , buildHut : Bool
    , buildLibrary : Bool
    , buildAcademy : Bool
    , buildBarn : Bool
    , buildMine : Bool
    , buildSmelter : Bool
    , buildWorkshop : Bool
    , craftWood : Bool
    }


initialOptions : Options
initialOptions =
    { gatherCatnip = False
    , observeSky = False
    , sendHunters = False
    , praiseSun = False
    , buildField = False
    , buildHut = False
    , buildLibrary = False
    , buildAcademy = False
    , buildBarn = False
    , buildMine = False
    , buildSmelter = False
    , buildWorkshop = False
    , craftWood = False
    }


type Tab
    = General
    | Build
    | Craft


type BuildingType
    = Field
    | Hut
    | Library
    | Academy
    | Barn
    | Mine
    | Smelter
    | Workshop


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
    | Minerals
    | Catpower
    | Science
    | Faith


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
