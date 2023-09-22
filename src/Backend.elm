module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId, broadcast, clientConnected_)
import List.Extra as Liste
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "Hello!"
      , activeSessions = []
      , activeClients = []
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        ClientConnected sid cid ->
            let
                sidExists =
                    List.member sid model.activeSessions

                cidExists =
                    List.member cid model.activeClients

                newSessions =
                    (if sidExists then
                        []

                     else
                        [ sid ]
                    )
                        ++ model.activeSessions

                newClients =
                    (if cidExists then
                        []

                     else
                        [ cid ]
                    )
                        ++ model.activeClients
            in
            ( { model | activeSessions = newSessions, activeClients = newClients }, broadcast (ClientJoined newClients) )

        ClientDisconnected sid cid ->
            let
                newClients =
                    Liste.remove cid model.activeClients
            in
            ( { model | activeClients = newClients }, broadcast (ClientLeft newClients) )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]
