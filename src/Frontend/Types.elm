module Frontend.Types exposing (ActiveSession(..), Model, Msg(..), State(..))

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Monstrous
import Players exposing (Hunter(..), Keeper(..), PlaybookName, Player(..), PlayerName)
import Url exposing (Url)


type alias Viewport =
    { width : Float, height : Float }


type alias Deets =
    { key : Key, url : String }


type alias Model =
    { deets : Deets
    , state : State
    , viewport : Maybe Viewport
    }


type State
    = EntryWay
    | BeforeSession (Maybe PlayerName)
    | ActiveSession ActiveSession


type ActiveSession
    = AddingPlayer (Maybe PlaybookName)
    | Playing Player


type Msg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | UpdateName String
    | SubmitButtonClicked
    | PlayBookNameClicked PlaybookName
    | Resize Float Float
    | ReceivedViewport Viewport
    | MonstrousMakerMessage Monstrous.Msg
