module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Core exposing (Rating(..))
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , session : Maybe Sesh
    , url : String
    }


type alias BackendModel =
    { message : String
    , session : Maybe Sesh
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId


type ToFrontend
    = NoOpToFrontend
    | ClientJoined (List ClientId)
    | ClientLeft (List ClientId)


type Keeper
    = Keeper Player


type Hunter
    = Hunter Player


type alias Player =
    { id : ClientId
    , name : String
    }


type alias Sesh =
    { keeper : Keeper
    , hunters : List Hunter
    }
