module Main exposing (..)

import Browser
import CustomElements exposing (..)
import Header exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)
import Message exposing (..)
import Model exposing (..)



-- HELPERS


apiUrl =
    "http://localhost:3002/"


staticResource : String -> String
staticResource src =
    apiUrl ++ "static/" ++ src



-- INIT


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
    field "printables" (Json.Decode.list (field "name" string))



-- UPDATE


unloaded : String -> ModelData
unloaded name =
    { name = name, loaded = False }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotList result ->
            case result of
                Ok list ->
                    ( Success { models = List.map unloaded list }, Cmd.none )

                Err why ->
                    ( Failure, Cmd.none )

        Load name ->
            case model of
                Success { models } ->
                    let
                        newModels =
                            List.map
                                (\x ->
                                    if x.name == name then
                                        { x | loaded = True }

                                    else
                                        x
                                )
                                models
                    in
                    ( Success { models = newModels }, Cmd.none )

                _ ->
                    ( Failure, Cmd.none )



-- VIEW


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
modelWithThumb { name, loaded } =
    viewModel name loaded


getModelSrc : String -> String
getModelSrc name =
    staticResource <| name ++ "/" ++ name ++ ".gltf"


getThumbSrc : String -> String
getThumbSrc name =
    staticResource <| name ++ "/" ++ name ++ ".jpg"


viewModel : String -> Bool -> Html Msg
viewModel name loaded =
    div []
        [ h2 [] [ text name ]
        , if loaded then
            modelViewer (getModelSrc name)

          else
            button [ onClick (Load name) ]
                [ img [ class "model-thumbnail", src (getThumbSrc name) ] []
                ]
        ]



-- PROGRAM


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
