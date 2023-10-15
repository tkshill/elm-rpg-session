module Backend exposing (..)

import Http exposing (Error(..), Response(..), task)
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Lamdera.Debug exposing (Response)
import Mark exposing (Document, Outcome(..))
import Mark.Error
import Parse exposing (PortfolioElement, parsepPortfolioDocument)
import Random
import Task exposing (Task)
import Time
import Types exposing (..)
import UUID exposing (UUID)
import Utility exposing (flip, withCmd, withNoCmd)


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
            model |> withNoCmd

        ClientConnected _ cid ->
            case model.state of
                Nothing ->
                    model
                        |> withCmd (sendToFrontend cid PotentialSteward)

                _ ->
                    model
                        |> withCmd (sendToFrontend cid PotentialProtagonist)

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
                { model | state = newState }
                    |> withCmd (sendToFrontend cid <| SessionCreated steward)

            else
                model |> withNoCmd


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Effect )
updateFromFrontend _ cid msg model =
    case msg of
        NoOpToBackend ->
            model |> withNoCmd

        CreateSession name ->
            model
                |> withCmd (uuidMaker <| IdCreated cid name)



-- EFFECTS --


uuidMaker : (UUID -> Msg) -> Effect
uuidMaker msgFunc =
    Time.posixToMillis
        >> Random.initialSeed
        >> Random.step UUID.generator
        >> Tuple.first
        >> msgFunc
        |> flip Task.perform Time.now


resolveDocument : Document a -> Response String -> Result Http.Error a
resolveDocument document response =
    case response of
        BadUrl_ url ->
            Err <| BadUrl url

        Timeout_ ->
            Err Timeout

        BadStatus_ { statusCode } _ ->
            Err <| BadStatus statusCode

        NetworkError_ ->
            Err NetworkError

        GoodStatus_ _ body ->
            let
                errorToErr =
                    List.map Mark.Error.toString
                        >> String.join "/n"
                        >> Http.BadBody
                        >> Err
            in
            case Mark.compile document body of
                Success success ->
                    Ok success

                Almost almost ->
                    errorToErr almost.errors

                Failure failure ->
                    errorToErr failure


fetchElement : (Response String -> Result Http.Error a) -> String -> Task Error a
fetchElement resolver name =
    task
        { method = "GET"
        , headers = []
        , url = "/" ++ name ++ ".emu"
        , body = Http.emptyBody
        , resolver = Http.stringResolver resolver
        , timeout = Nothing
        }



-- fetchPortfolios =
--     Task.sequence <| List.map fetchPortfolio [ "TheArcance", "TheMortal", "TheUnnatural" ]
-- SUBSCRIPTIONS --


subscriptions : Model -> Listener
subscriptions _ =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]
