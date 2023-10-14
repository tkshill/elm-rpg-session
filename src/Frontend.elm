module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Dom exposing (getViewport)
import Browser.Events as E
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Input as Input exposing (button, labelLeft, placeholder)
import Lamdera exposing (sendToBackend)
import Task
import Types exposing (..)
import Unnatural exposing (UnnaturalName(..), makerModel)
import Url
import Utility exposing (withCmd, withNoCmd)


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


type alias Effect =
    Cmd Msg


type alias UiElement =
    Element Msg


getInitialViewport : Effect
getInitialViewport =
    let
        handleResult v =
            case v of
                Err _ ->
                    NoOpFrontendMsg

                Ok vp ->
                    ReceivedViewport { width = vp.viewport.width, height = vp.viewport.height }
    in
    Task.attempt handleResult getViewport


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Effect )
init { path } key =
    ( { deets = Deets key path
      , state = BeforeSession Nothing
      , viewport = Nothing
      }
    , getInitialViewport
    )


update : Msg -> Model -> ( Model, Effect )
update msg model =
    case ( msg, model.state ) of
        ( UrlClicked urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.deets.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ( UpdateName s, BeforeSession _ ) ->
            { model | state = BeforeSession (Just s) } |> withNoCmd

        ( SubmitButtonClicked, BeforeSession (Just s) ) ->
            model |> withCmd (sendToBackend <| CreateSession s)

        ( PortfolioClicked playbookName, ActiveSession (AddingPlayer _) ) ->
            { model | state = ActiveSession (AddingPlayer (Just playbookName)) } |> withNoCmd

        ( Resize w h, _ ) ->
            { model | viewport = Just { width = w, height = h } } |> withNoCmd

        _ ->
            model |> withNoCmd


updateFromBackend : ToFrontend -> Model -> ( Model, Effect )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            model |> withNoCmd

        PotentialSteward ->
            { model | state = BeforeSession Nothing } |> withNoCmd

        SessionCreated steward ->
            { model | state = ActiveSession (Playing (StewardPlayer steward)) } |> withNoCmd

        PotentialProtagonist ->
            { model | state = ActiveSession (AddingPlayer Nothing) } |> withNoCmd


viewStartSessionForm : Maybe String -> UiElement
viewStartSessionForm maybeName =
    let
        name =
            Maybe.withDefault "" maybeName
    in
    column []
        [ Input.text [] { onChange = UpdateName, text = "", label = labelLeft [] (text "Character Name"), placeholder = Just (placeholder [] (text "Buttercup")) } --[ placeholder "Enter your name", value name, onInput UpdateName ] []
        , button [] { onPress = Just SubmitButtonClicked, label = text "Submit" }
        ]


viewPlaybooks : List PortfolioName -> UiElement
viewPlaybooks playbooks =
    column []
        [ text "Select a Playbook"
        , column [] <| List.map viewPlaybook playbooks
        ]


viewPlaybook : PortfolioName -> UiElement
viewPlaybook playbookName =
    button [] { onPress = Just (PortfolioClicked playbookName), label = text (playbookNameToString playbookName) }


viewActiveSession : ActiveSession -> Element Msg
viewActiveSession session =
    case session of
        AddingPlayer Nothing ->
            viewPlaybooks [ U UnnaturalName ]

        AddingPlayer (Just name) ->
            case name of
                U UnnaturalName ->
                    Unnatural.viewMaker MonstrousMakerMessage makerModel

        Playing player ->
            el [] <| text "You're playing"


viewState : FrontEndState -> UiElement
viewState state =
    case state of
        EntryWay ->
            el [] none

        BeforeSession ms ->
            viewStartSessionForm ms

        ActiveSession sesh ->
            viewActiveSession sesh


playbookNameToString : PortfolioName -> String
playbookNameToString playbook =
    case playbook of
        U name ->
            Unnatural.toString name


view : Model -> Browser.Document Msg
view model =
    { title = "Monster Of The Week"
    , body =
        [ layout [ width fill, height fill ] <|
            column []
                [ image [ width (px 150) ] { src = "https://lamdera.app/lamdera-logo-black.png", description = "Lamdera logo" }
                , viewState model.state
                ]
        ]
    }


subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize (toFloat w) (toFloat h))
