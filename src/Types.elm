module Types exposing (..)

import Frontend.Types as FT
import Lamdera exposing (ClientId, SessionId)
import Players
    exposing
        ( Hunter
        , Keeper
        , PlayerName
        )
import UUID exposing (UUID)


type alias FrontendModel =
    FT.Model


type alias BackendModel =
    { message : String
    , state : Maybe BackEndSession
    }


type alias FrontendMsg =
    FT.Msg


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
    | PotentialKeeper
    | PotentialHunter
    | SessionCreated Keeper


type alias Player =
    { id : ClientId
    , name : String
    }


type alias BackEndSession =
    { keeper : Keeper
    , hunters : List Hunter
    }
