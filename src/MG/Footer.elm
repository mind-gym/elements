module MG.Footer exposing (footer)

{-|


# Footer

@docs footer

-}

import Element exposing (..)
import Element.Font as Font
import MG.Colours exposing (colours)
import MG.Typography as Typography
import MG.Viewport exposing (Viewport, Width(..))


type alias FooterLink =
    { str : String
    , url : String
    }


footerLink : Viewport -> FooterLink -> Element msg
footerLink viewport { str, url } =
    link
        [ case viewport.size of
            AtLeast1440Wide ->
                alignRight

            _ ->
                alignLeft
        , alignBottom
        ]
        { url = url
        , label = text str
        }


{-| Standard footer
-}
footer : Viewport -> List FooterLink -> Element msg
footer viewport links =
    wrappedRow
        (Typography.noteL.regular viewport
            ++ [ width fill
               , paddingXY 20 30
               , Font.color colours.black300
               , spacing 20
               ]
        )
    <|
        List.map (footerLink viewport) links
