module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Core exposing (Rating(..))
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , session : FEState
    , url : String
    }


type alias BackendModel =
    { message : String
    , session : Maybe BackEndSession
    }


type FEState
    = Presession (Maybe String)
    | ActiveSession FrontEndSession


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | UpdateName String
    | SubmitButtonClicked


type ToBackend
    = NoOpToBackend
    | CreateSession String


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId


type ToFrontend
    = NoOpToFrontend
    | SessionCreated FrontEndSession


type Keeper
    = Keeper Player


type Hunter
    = Hunter Player


type alias Player =
    { id : ClientId
    , name : String
    }


type alias SessionDetails =
    { keeper : Keeper
    , hunters : List Hunter
    }


type alias BackEndSession =
    SessionDetails


type FrontEndSession
    = KeeperSession SessionDetails
    | HunterSession SessionDetails
