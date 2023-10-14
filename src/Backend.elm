module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Random
import Task
import Time
import Types exposing (..)
import UUID exposing (UUID)
import Utility exposing (flip, withModel, withNoCmd)


type alias Model =
    BackendModel


type alias Msg =
    BackendMsg


type alias Effect =
    Cmd BackendMsg


type alias Listener =
    Sub BackendMsg


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Effect )
init =
    { message = "Hello!"
    , state = Nothing
    }
        |> withNoCmd


update : BackendMsg -> Model -> ( Model, Effect )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        ClientConnected _ cid ->
            case model.state of
                Nothing ->
                    sendToFrontend cid PotentialSteward
                        |> withModel model

                _ ->
                    sendToFrontend cid PotentialProtagonist
                        |> withModel model

        ClientDisconnected _ _ ->
            model |> withNoCmd

        IdCreated cid name uuid ->
            if model.state == Nothing then
                let
                    steward =
                        Steward uuid name

                    newState =
                        Just { steward = steward, protagonists = [] }
                in
                sendToFrontend cid (SessionCreated steward)
                    |> withModel { model | state = newState }

            else
                model |> withNoCmd


uuidMaker : (UUID -> Msg) -> Effect
uuidMaker msgFunc =
    Time.posixToMillis
        >> Random.initialSeed
        >> Random.step UUID.generator
        >> Tuple.first
        >> msgFunc
        |> flip Task.perform Time.now


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Effect )
updateFromFrontend _ cid msg model =
    case msg of
        NoOpToBackend ->
            model |> withNoCmd

        CreateSession name ->
            uuidMaker (IdCreated cid name)
                |> withModel model


subscriptions : Model -> Listener
subscriptions _ =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]
