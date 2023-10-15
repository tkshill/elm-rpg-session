module Types exposing (..)

import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId, Url, UrlRequest)
import Portfolio exposing (UnnaturalName)
import UUID exposing (UUID)


type alias PlayerName =
    String


type alias PlayerID =
    UUID


type Steward
    = Steward PlayerID PlayerName


type Protagonist
    = Protagonist PlayerID PlayerName


type Player
    = StewardPlayer Steward
    | ProtagonistPlayer Protagonist


type PortfolioName
    = U UnnaturalName


type alias BackendModel =
    { message : String
    , state : Maybe BackEndSession
    }


type alias Viewport =
    { width : Float, height : Float }


type alias Deets =
    { key : Key, url : String }


type alias FrontendModel =
    { deets : Deets
    , state : FrontEndState
    , viewport : Maybe Viewport
    }


type FrontEndState
    = EntryWay
    | BeforeSession (Maybe PlayerName)
    | ActiveSession ActiveSession


type ActiveSession
    = AddingPlayer (Maybe PortfolioName)
    | Playing Player


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | UpdateName String
    | SubmitButtonClicked
    | PortfolioClicked PortfolioName
    | Resize Float Float
    | ReceivedViewport Viewport
    | MonstrousMakerMessage GameElements.Msg


type ToBackend
    = NoOpToBackend
    | CreateSession String


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | IdCreated ClientId PlayerName UUID


type ToFrontend
    = NoOpToFrontend
    | PotentialSteward
    | PotentialProtagonist
    | SessionCreated Steward


type alias BackEndSession =
    { steward : Steward
    , protagonists : List Protagonist
    }
