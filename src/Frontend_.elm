module Frontend_ exposing (ActiveSession(..), Model, State(..))

import Browser.Navigation exposing (Key)
import Players exposing (Hunter(..), Keeper(..), PlaybookName, Player(..), PlayerName)


type alias Deets =
    { key : Key, url : String }


type alias Model =
    { deets : Deets
    , state : State
    }


type State
    = EntryWay
    | BeforeSession (Maybe PlayerName)
    | ActiveSession ActiveSession


type ActiveSession
    = AddingPlayer (Maybe PlaybookName)
    | Playing Player
