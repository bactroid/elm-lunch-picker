module Main exposing (..)

import Html exposing (Html, button, div, text, h2, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, class)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", getRandomRestaurant apiUrl )



-- UPDATE


type Msg
    = GetRandomRestaurant
    | NewRestaurant (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRandomRestaurant ->
            ( model, getRandomRestaurant apiUrl )

        NewRestaurant (Ok newRestaurant) ->
            ( newRestaurant, Cmd.none )

        NewRestaurant (Err _) ->
            ( model, Cmd.none )


apiUrl : String
apiUrl =
    "https://6zkojio7gj.execute-api.us-east-1.amazonaws.com/dev/lunch"


getRandomRestaurant : String -> Cmd Msg
getRandomRestaurant url =
    Http.send NewRestaurant (Http.get url decodeResp)


decodeResp : Decode.Decoder String
decodeResp =
    Decode.at [ "text" ] Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ classList
            [ ( "mdl-card", True )
            , ( "mdl-shadow--4dp", True )
            ]
        ]
        [ div [ class "mdl-card__title" ] [ h2 [ class "mdl-card__title-text" ] [ text "Today, for lunch, I recommend…" ] ]
        , div [ class "mdl-card__supporting-text" ] [ text model ]
        , div [ class "mdl-card__actions" ]
            [ a
                [ onClick GetRandomRestaurant
                , classList
                    [ ( "mdl-button", True )
                    , ( "mdl-js-button", True )
                    , ( "mdl-button--raised", True )
                    , ( "mdl-js-ripple-effect", True )
                    , ( "mdl-button--accent", True )
                    ]
                ]
                [ text "Nah. Pick something else." ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
