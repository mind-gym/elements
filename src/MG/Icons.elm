module MG.Icons exposing (show, hide, rightArrow, leftArrow, warning, success, logOut, cross, plus, chevronDown, chevronUp, chevronRight, expand, collapse, hamburger)

{-|


# Icons

@docs show, hide, rightArrow, leftArrow, warning, success, logOut, cross, plus, chevronDown, chevronUp, chevronRight, expand, collapse, hamburger

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


{-| -}
warning : Int -> Element msg
warning =
    icon Icons.warning_amber


{-| -}
success : Int -> Element msg
success =
    icon Icons.check_circle


{-| -}
logOut : Int -> Element msg
logOut =
    icon Icons.logout


{-| -}
plus : Int -> Element msg
plus =
    icon Icons.add


{-| -}
cross : Int -> Element msg
cross =
    icon Icons.close


{-| -}
chevronRight : Int -> Element msg
chevronRight =
    icon Icons.chevron_right


{-| -}
chevronDown : Int -> Element msg
chevronDown =
    el [ rotate <| degrees 90 ] << chevronRight


{-| -}
chevronUp : Int -> Element msg
chevronUp =
    el [ rotate <| degrees 270 ] << chevronRight


{-| -}
expand : Int -> Element msg
expand size =
    column []
        [ chevronUp <| size // 2
        , chevronDown <| size // 2
        ]


{-| -}
collapse : Int -> Element msg
collapse size =
    column []
        [ chevronDown <| size // 2
        , chevronUp <| size // 2
        ]


{-| -}
hamburger : Int -> Element msg
hamburger =
    icon Icons.visibility
