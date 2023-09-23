module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId, broadcast)
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
      , session = Nothing
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        ClientConnected _ _ ->
            ( model, Cmd.none )

        ClientDisconnected _ _ ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ cid msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        CreateSession name ->
            let
                keeper =
                    Keeper { id = cid, name = name }

                session =
                    { keeper = keeper, hunters = [] }
            in
            ( { model | session = Just session }, broadcast (SessionCreated (KeeperSession session)) )


subscriptions : Model -> Sub BackendMsg
subscriptions _ =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]
