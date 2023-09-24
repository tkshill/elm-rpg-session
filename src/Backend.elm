module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Players exposing (Keeper(..), PlayerName)
import Random
import Task
import Time
import Types exposing (..)
import UUID exposing (UUID)
import Utility exposing (fst)


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
      , state = Nothing
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        ClientConnected _ cid ->
            case model.state of
                Nothing ->
                    ( model, sendToFrontend cid PotentialKeeper )

                _ ->
                    ( model, sendToFrontend cid PotentialHunter )

        ClientDisconnected _ _ ->
            ( model, Cmd.none )

        IdCreated cid name uuid ->
            if model.state == Nothing then
                let
                    keeper =
                        Keeper uuid name

                    newState =
                        Just { keeper = keeper, hunters = [] }
                in
                ( { model | state = newState }, sendToFrontend cid (SessionCreated keeper) )

            else
                ( model, Cmd.none )


uuidMaker : (ClientId -> PlayerName -> UUID -> BackendMsg) -> ClientId -> PlayerName -> Cmd BackendMsg
uuidMaker f cid name =
    Time.now
        |> Task.perform
            (Time.posixToMillis
                >> Random.initialSeed
                >> Random.step UUID.generator
                >> fst
                >> f cid name
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ cid msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        CreateSession name ->
            ( model, uuidMaker IdCreated cid name )


subscriptions : Model -> Sub BackendMsg
subscriptions _ =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]
