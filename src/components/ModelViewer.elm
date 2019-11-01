module ModelViewer exposing (..)

import CustomElements exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, src)


viewModel : String -> String -> Bool -> Html msg
viewModel modelSrc thumbnailSrc loaded =
    if loaded then
        modelViewer modelSrc

    else
        img [ src thumbnailSrc ] []
