module Main exposing (..)

import Html exposing (Html, button, div, text, h2, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, class)
import Http
import Json.Decode as Decode
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options


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
    div
        [ classList
            [ ( "mdl-card", True )
            , ( "mdl-shadow--4dp", True )
            ]
        ]
        [ div [ class "mdl-card__title" ] [ h2 [ class "mdl-card__title-text" ] [ text "Today, for lunch, I recommend…" ] ]
        , div [ class "mdl-card__supporting-text" ] [ text model.restaurant ]
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick GetRandomRestaurant
            ]
            [ text "Nah. Pick something else." ]
        ]
        |> Material.Scheme.top



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
