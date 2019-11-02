module Main exposing (..)

import Browser
import CustomElements exposing (..)
import Header exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, list, string)


apiUrl =
    "http://localhost:3002/"



---- MODEL ----


type alias ModelData =
    { modelSrc : String, loaded : Bool }


type Model
    = Failure
    | Loading
    | Success { models : List ModelData }


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
    | Load String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotList result ->
            case result of
                Ok list ->
                    ( Success { models = List.map (\s -> { modelSrc = s, loaded = False }) list }, Cmd.none )

                Err why ->
                    ( Failure, Cmd.none )

        Load src ->
            case model of
                Success { models } ->
                    let
                        newModels =
                            List.map
                                (\x ->
                                    if x.modelSrc == src then
                                        { modelSrc = src, loaded = True }

                                    else
                                        x
                                )
                                models
                    in
                    ( Success { models = newModels }, Cmd.none )

                _ ->
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


modelWithThumb : ModelData -> Html Msg
modelWithThumb { modelSrc, loaded } =
    viewModel modelSrc "https://marianatura.es/wp-content/uploads/2015/08/Chorizo-Barbacoa-Dulce.jpg" loaded


viewModel : String -> String -> Bool -> Html Msg
viewModel modelSrc thumbnailSrc loaded =
    if loaded then
        modelViewer (apiUrl ++ "static/" ++ modelSrc)

    else
        button [ onClick (Load modelSrc) ]
            [ img [ src thumbnailSrc ] []
            ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
