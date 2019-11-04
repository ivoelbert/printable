module Model exposing (..)

-- MODEL


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