module Main exposing (..)

import Html exposing (Html, button, div, text, h2, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, class)
import Http
import Json.Decode as Decode
import Material
import Material.Scheme
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Options as Options exposing (css)


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
    -- String
    { restaurant : String
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { restaurant = "", mdl = Material.model }, getRandomRestaurant apiUrl )



-- UPDATE


type Msg
    = GetRandomRestaurant
    | NewRestaurant (Result Http.Error String)
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRandomRestaurant ->
            ( model
            , getRandomRestaurant apiUrl
            )

        NewRestaurant (Ok newRestaurant) ->
            ( { model | restaurant = newRestaurant }
            , Cmd.none
            )

        NewRestaurant (Err _) ->
            ( model
            , Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ model


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
    Card.view
        [ css "width" "400px"
        , Elevation.e4
        ]
        [ Card.title
            [ Color.background (Color.color Color.Blue Color.S400)
            , css "height" "100px"
            , css "padding" "0"
            ]
            [ Card.head
                [ Color.text Color.white
                , Options.scrim 0.75
                , css "padding" "16px"
                , css "width" "100%"
                ]
                [ text "Today, for lunch, I recommend…" ]
            ]
        , Card.text [] [ text model.restaurant ]
        , Card.actions
            [ Card.border ]
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.raised
                , Button.colored
                , Button.ripple
                , Options.onClick GetRandomRestaurant
                ]
                [ text "Nah. Pick something else." ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
