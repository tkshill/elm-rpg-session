module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Core exposing (Rating(..))
import Frontend_ exposing (Model)
import Lamdera exposing (ClientId, SessionId)
import Monstrous exposing (MonstrousName)
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


type alias Player =
    { id : ClientId
    , name : String
    }


type alias BackEndSession =
    SessionDetails


type PlaybookName
    = M MonstrousName
