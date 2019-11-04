module Message exposing (..)

import Http
import Model exposing (..)



-- MESSAGE


type Msg
    = GotList (Result Http.Error (List ApiResponse))
    | Load String