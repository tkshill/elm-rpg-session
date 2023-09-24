module Core exposing
    ( Hunter(..)
    , Keeper(..)
    , PlaybookName(..)
    , Player(..)
    , PlayerName
    , Rating(..)
    , playbookNameToString
    )

import Monstrous exposing (MonstrousName)
import UUID exposing (UUID)


type BaseKarma
    = Int


type Charm
    = Charm


type Weird
    = Weird


type Sharp
    = Sharp


type Guts
    = Guts


type Rating
    = C Charm
    | W Weird
    | S Sharp
    | G Guts



-- type alias BaseRatings =
--     { charm : Int
--     , weird : Int
--     , sharp : Int
--     , guts : Int
--     }
-- type alias Gear =
--     { name : String
--     , tags : Listn.Nonempty String
--     }
-- type Alteration
--     = PlusOne
--     | MinusOne
--     | Neutral
-- type alias Move =
--     { name : String
--     , description : String
--     , moveType : MoveType
--     }
-- type MoveType
--     = FlavourMove
--     | RollMove Rating
--     | ModMove Modifier
-- type alias BasePlayBook =
--     { name : String
--     , description : String
--     , ratings : BaseRatings
--     , moves : List Move
--     , gear : List Gear
--     , karma : BaseKarma
--     }
-- type BasicMoveName
--     = Help
--     | Engage
--     | Sway
--     | Assess
--     | Act
--     | Avoid
--     | GetWeird
-- type alias GearStatModifier =
--     { name : String
--     , harm : Int
--     , harmMods : Int
--     , tags : String
--     }
-- type Modifier
--     = HarmMods Int
--     | KarmaMods Int
--     | RatingMods Rating Int
--     | GearsMods (List Gear)
--     | GearStatMods GearStatModifier


type alias PlayerName =
    String


type alias PlayerID =
    UUID


type Keeper
    = Keeper PlayerID PlayerName


type Hunter
    = Hunter PlayerID PlayerName


type Player
    = K Keeper
    | H Hunter


type PlaybookName
    = M MonstrousName


playbookNameToString : PlaybookName -> String
playbookNameToString playbook =
    case playbook of
        M name ->
            Monstrous.toString name
