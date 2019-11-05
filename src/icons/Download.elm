{-
   <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
       <path d="M5 4v2h14V4H5zm0 10h4v6h6v-6h4l-7-7-7 7z" />
   </svg>
-}


module Download exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute)
import Svg exposing (..)
import Svg.Attributes exposing (..)


downloadIcon : Bool -> Html msg
downloadIcon clicked =
    svg [ class "download-icon", width "24", height "24", viewBox "0 0 24 24" ]
        [ Svg.path [ attribute "d" "M5 4v2h14V4H5zm0 10h4v6h6v-6h4l-7-7-7 7z" ] []
        ]
