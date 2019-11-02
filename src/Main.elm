module Main exposing (..)

import Browser
import CustomElements exposing (..)
import Header exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)


apiUrl =
    "http://localhost:3002/"


staticResource : String -> String
staticResource src =
    apiUrl ++ "static/" ++ src



---- MODEL ----


type alias ApiResponse =
    { modelSrc : String, thumbSrc : String }


type alias WithLoaded a =
    { a | loaded : Bool }


type alias ModelData =
    WithLoaded ApiResponse


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


listDecoder : Decoder (List ApiResponse)
listDecoder =
    field "printables" (list (map2 ApiResponse (field "modelSrc" string) (field "thumbSrc" string)))



---- UPDATE ----


type Msg
    = GotList (Result Http.Error (List ApiResponse))
    | Load String


unloaded : ApiResponse -> ModelData
unloaded { modelSrc, thumbSrc } =
    { modelSrc = modelSrc, thumbSrc = thumbSrc, loaded = False }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotList result ->
            case result of
                Ok list ->
                    ( Success { models = List.map unloaded list }, Cmd.none )

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
                                        { x | loaded = True }

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
modelWithThumb { modelSrc, thumbSrc, loaded } =
    viewModel modelSrc thumbSrc loaded


viewModel : String -> String -> Bool -> Html Msg
viewModel modelSrc thumbnailSrc loaded =
    if loaded then
        modelViewer (staticResource modelSrc)

    else
        button [ onClick (Load modelSrc) ]
            [ img [ src (staticResource thumbnailSrc) ] []
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
