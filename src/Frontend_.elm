module Frontend_ exposing (..)
import Browser.Navigation exposing (Key)
import Core exposing (Keeper(..))
import Core exposing (Hunter)

type alias Deets = {
    key: Key
    , url: String
}

type alias Model =
    { deets: Deets
    , state : State
    }

type alias Name = String

type State
    = BeforeSession (Maybe Name)
    | ActiveSession ActiveSession

type ActiveSession = 
    | AddingPlayers Keeper (List Hunter) 
    | PlayingGame Keeper (List Hunter)