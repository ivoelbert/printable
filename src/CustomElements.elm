module CustomElements exposing (modelViewer)

import Browser
import Html exposing (Attribute, Html, div, h2, strong, text)
import Html.Attributes exposing (attribute)


type alias ModelViewerData =
    { backgroundColor : String
    , autoRotateDelay : Float
    , autoRotate : Bool
    , cameraControls : Bool
    , src : String
    }


modelViewerBase : List (Attribute a) -> List (Html a) -> Html a
modelViewerBase =
    Html.node "model-viewer"


modelViewer : String -> Html a
modelViewer src =
    modelViewerBase [ attribute "background-color" "#fafafa", attribute "src" src, attribute "camera-controls" "true", attribute "auto-rotate" "true" ] []
