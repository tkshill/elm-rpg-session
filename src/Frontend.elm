module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (Html, button, div, input, text)
import Html.Attributes as Attr exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Lamdera exposing (sendToBackend)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


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
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , session = Presession Nothing
      , url = url.path
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case ( msg, model.session ) of
        ( UrlClicked urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ( UpdateName s, Presession _ ) ->
            ( { model | session = Presession (Just s) }, Cmd.none )

        ( SubmitButtonClicked, Presession (Just s) ) ->
            ( model, sendToBackend (CreateSession s) )

        _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        SessionCreated session ->
            ( { model | session = ActiveSession session }, Cmd.none )


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


viewSession : FrontEndSession -> Html msg
viewSession session =
    case session of
        KeeperSession details ->
            let
                (Keeper player) =
                    details.keeper
            in
            div [] [ text ("You are the keeper!" ++ player.name) ]

        HunterSession _ ->
            div [] [ text "You are a hunter!" ]


viewState : FEState -> Html FrontendMsg
viewState state =
    case state of
        Presession ms ->
            viewStartSessionForm ms

        ActiveSession sesh ->
            viewSession sesh


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
                [ viewState model.session ]
            ]
        ]
    }
