module Models exposing (..)


type alias Model =
    { options : Options
    , currentTab : Tab
    , hutPriceReduction : Float
    , priceReduction : Float
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
    , buildLogHouse : Bool
    , buildAcademy : Bool
    , buildBarn : Bool
    , buildMine : Bool
    , buildLumberMill : Bool
    , buildSmelter : Bool
    , buildWorkshop : Bool
    , buildTradepost : Bool
    , craftWood : Bool
    , craftBeam : Bool
    , craftSlab : Bool
    , craftPlate : Bool
    , craftSteel : Bool
    , craftKerosene : Bool
    , craftParchment : Bool
    , craftManuscript : Bool
    , craftCompendium : Bool
    , craftThorium : Bool
    }


initialOptions : Options
initialOptions =
    { gatherCatnip = False
    , observeSky = False
    , sendHunters = False
    , praiseSun = False
    , buildField = False
    , buildHut = False
    , buildLogHouse = False
    , buildLibrary = False
    , buildAcademy = False
    , buildBarn = False
    , buildMine = False
    , buildLumberMill = False
    , buildSmelter = False
    , buildWorkshop = False
    , buildTradepost = False
    , craftWood = False
    , craftBeam = False
    , craftSlab = False
    , craftPlate = False
    , craftSteel = False
    , craftKerosene = False
    , craftParchment = False
    , craftManuscript = False
    , craftCompendium = False
    , craftThorium = False
    }


type Tab
    = General
    | Build
    | Craft


type BuildingType
    = Field
    | Hut
    | LogHouse
    | Library
    | Academy
    | Barn
    | Mine
    | LumberMill
    | Smelter
    | Workshop
    | Tradepost


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
    | Coal
    | Iron
    | Gold
    | Uranium
    | Oil
    | Catpower
    | Science
    | Culture
    | Faith
    | Furs
    | Parchment
    | Manuscript
    | Compendium


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
    | CraftBeam
    | CraftSlab
    | CraftPlate
    | CraftSteel
    | CraftKerosene
    | CraftParchment
    | CraftManuscript
    | CraftCompendium
    | CraftThorium


type alias Recipe =
    { recipeType : RecipeType
    , unlocked : Bool
    , prices : List Price
    }
