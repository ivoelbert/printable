module Main exposing (..)

import Browser
import Header exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, src)
import Http
import Json.Decode exposing (Decoder, field, list, string)
import ModelViewer exposing (..)


apiUrl =
    "http://localhost:3002/"



---- MODEL ----


type Model
    = Failure
    | Loading
    | Success { models : List String, loaded : List String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getList )


getList : Cmd Msg
getList =
    Http.get
        { url = apiUrl ++ "list-models"
        , expect = Http.expectJson GotList listDecoder
        }


listDecoder : Decoder (List String)
listDecoder =
    field "printables" (list string)



---- UPDATE ----


type Msg
    = GotList (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotList result ->
            case result of
                Ok list ->
                    ( Success { models = list, loaded = [] }, Cmd.none )

                Err why ->
                    ( Failure, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ pageHeader
        , viewList model
        ]


viewList : Model -> Html Msg
viewList model =
    case model of
        Failure ->
            p [] [ text "Something went wrong :(" ]

        Loading ->
            p [] [ text "Loading list..." ]

        Success { models } ->
            div [] (List.map modelWithThumb models)


modelWithThumb : String -> Html Msg
modelWithThumb url =
    viewModel (apiUrl ++ "static/" ++ url) "https://marianatura.es/wp-content/uploads/2015/08/Chorizo-Barbacoa-Dulce.jpg" False



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
