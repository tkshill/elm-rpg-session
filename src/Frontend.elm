module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Frontend.Types exposing (ActiveSession(..), State(..))
import Html exposing (Html, button, div, input, p, text, ul)
import Html.Attributes as Attr exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Lamdera exposing (sendToBackend)
import Monstrous exposing (MonstrousName(..), makerModel)
import Players exposing (PlaybookName(..), Player(..), playbookNameToString)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


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


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { deets = { key = key, url = url.path }
      , state = BeforeSession Nothing
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
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
            ( { model | state = BeforeSession (Just s) }, Cmd.none )

        ( SubmitButtonClicked, BeforeSession (Just s) ) ->
            ( model, sendToBackend (CreateSession s) )

        ( PlayBookNameClicked playbookName, ActiveSession (AddingPlayer _) ) ->
            ( { model | state = ActiveSession (AddingPlayer (Just playbookName)) }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        PotentialKeeper ->
            ( { model | state = BeforeSession Nothing }, Cmd.none )

        SessionCreated keeper ->
            ( { model | state = ActiveSession (Playing (K keeper)) }, Cmd.none )

        PotentialHunter ->
            ( { model | state = ActiveSession (AddingPlayer Nothing) }, Cmd.none )


viewStartSessionForm : Maybe String -> Html FrontendMsg
viewStartSessionForm maybeName =
    let
        name =
            Maybe.withDefault "" maybeName
    in
    div []
        [ input [ placeholder "Enter your name", value name, onInput UpdateName ] []
        , button [ onClick SubmitButtonClicked ] [ text "Submit" ]
        ]


viewPlaybooks : List PlaybookName -> Html Msg
viewPlaybooks playbooks =
    div []
        [ p [] [ text "Select a Playbook" ]
        , ul [] (List.map viewPlaybook playbooks)
        ]


viewPlaybook : PlaybookName -> Html Msg
viewPlaybook playbookName =
    button [ onClick (PlayBookNameClicked playbookName) ] [ text (playbookNameToString playbookName) ]


viewActiveSession : ActiveSession -> Html Msg
viewActiveSession session =
    case session of
        AddingPlayer Nothing ->
            viewPlaybooks [ M MonstrousName ]

        AddingPlayer (Just name) ->
            case name of
                M MonstrousName ->
                    Monstrous.viewMaker makerModel

        Playing player ->
            div [] [ text "You're playing" ]


viewState : State -> Html FrontendMsg
viewState state =
    case state of
        EntryWay ->
            div [] []

        BeforeSession ms ->
            viewStartSessionForm ms

        ActiveSession sesh ->
            viewActiveSession sesh


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            [ Html.img [ Attr.src "https://lamdera.app/lamdera-logo-black.png", Attr.width 150 ] []
            , Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding-top" "40px"
                ]
                [ viewState model.state ]
            ]
        ]
    }
