module Types exposing (..)

import Browser exposing (UrlRequest)
import Frontend_ exposing (Model)
import Lamdera exposing (ClientId, SessionId)
import Players
    exposing
        ( Hunter
        , Keeper
        , PlaybookName
        , PlayerName
        )
import UUID exposing (UUID)
import Url exposing (Url)


type alias FrontendModel =
    Model


type alias BackendModel =
    { message : String
    , state : Maybe BackEndSession
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | UpdateName String
    | SubmitButtonClicked
    | PlayBookNameClicked PlaybookName


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
