module Header exposing (..)

import Browser
import Html exposing (..)


pageHeader : Html a
pageHeader =
    header []
        [ h1 [] [ text "Printables!" ]
        ]
