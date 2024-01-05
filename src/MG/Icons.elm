module MG.Icons exposing (show, hide, rightArrow, leftArrow)

{-|


# Icons

@docs show, hide, rightArrow, leftArrow

-}

import Element exposing (..)
import Html exposing (Html)
import Material.Icons as Icons
import Material.Icons.Types as IconTypes


icon : (b -> IconTypes.Coloring -> Html msg) -> b -> Element msg
icon i size =
    html <|
        i size IconTypes.Inherit


{-| -}
show : Int -> Element msg
show =
    icon Icons.visibility


{-| -}
hide : Int -> Element msg
hide =
    icon Icons.visibility_off


{-| -}
rightArrow : Int -> Element msg
rightArrow =
    icon Icons.arrow_forward


{-| -}
leftArrow : Int -> Element msg
leftArrow =
    icon Icons.arrow_back
