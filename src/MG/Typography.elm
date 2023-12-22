module MG.Typography exposing
    ( headingXXL, headingXL, headingL, headingM, headingS, headingXS, headingXXS
    , bodyXL, bodyL, bodyS
    , leadL, leadS, noteL, noteS
    )

{-| #Typography

This module provides a set of type styles.


## Headings

@docs headingXXL, headingXL, headingL, headingM, headingS, headingXS, headingXXS


## Body text

@docs bodyXL, bodyL, bodyS


## Other

@docs leadL, leadS, noteL, noteS

-}

import Element exposing (Attribute)
import Element.Font as Font
import MG.Viewport exposing (PerBreakpoint, Viewport, Width(..), perBreakpoint)


type alias TypeStyle msg =
    Viewport -> List (Attribute msg)


typeStyle : WeightedTypeface -> PerBreakpoint TypeSizing -> TypeStyle msg
typeStyle weightedTypeface perBreakpointTypeSizing viewport =
    let
        typeSizing =
            perBreakpoint perBreakpointTypeSizing viewport
    in
    styledAttributes
        weightedTypeface.fontFamily
        weightedTypeface.fontWeight
        typeSizing.fontSize
        typeSizing.lineHeight
        (if typeSizing.letterSpacing == 0 then
            []

         else
            [ Font.letterSpacing typeSizing.letterSpacing ]
        )


type alias TypeStylePair msg =
    { medium : TypeStyle msg
    , regular : TypeStyle msg
    }


typeStylePair : FontFamily -> PerBreakpoint TypeSizing -> TypeStylePair msg
typeStylePair fontFamily perBreakpointTypeSizing =
    { medium = typeStyle { fontFamily = fontFamily, fontWeight = Medium500 } perBreakpointTypeSizing
    , regular = typeStyle { fontFamily = fontFamily, fontWeight = Regular400 } perBreakpointTypeSizing
    }


type alias WeightedTypeface =
    { fontFamily : FontFamily
    , fontWeight : FontWeight
    }


type alias TypeSizing =
    { fontSize : Int
    , lineHeight : Int
    , letterSpacing : Float
    }


{-| -}
headingXXL : TypeStyle msg
headingXXL =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 80
            , lineHeight = 88
            , letterSpacing = -1.6
            }
        , atLeast1024Wide =
            { fontSize = 60
            , lineHeight = 64
            , letterSpacing = -1.0
            }
        , atLeast768Wide =
            { fontSize = 44
            , lineHeight = 48
            , letterSpacing = -0.6
            }
        , default360 =
            { fontSize = 38
            , lineHeight = 42
            , letterSpacing = -0.6
            }
        }


{-| -}
headingXL : TypeStyle msg
headingXL =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 60
            , lineHeight = 64
            , letterSpacing = -1
            }
        , atLeast1024Wide =
            { fontSize = 44
            , lineHeight = 48
            , letterSpacing = -0.6
            }
        , atLeast768Wide =
            { fontSize = 36
            , lineHeight = 40
            , letterSpacing = -0.4
            }
        , default360 =
            { fontSize = 34
            , lineHeight = 38
            , letterSpacing = -0.4
            }
        }


{-| -}
headingL : TypeStyle msg
headingL =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 48
            , lineHeight = 52
            , letterSpacing = -0.6
            }
        , atLeast1024Wide =
            { fontSize = 36
            , lineHeight = 40
            , letterSpacing = -0.4
            }
        , atLeast768Wide =
            { fontSize = 30
            , lineHeight = 36
            , letterSpacing = -0.4
            }
        , default360 =
            { fontSize = 30
            , lineHeight = 36
            , letterSpacing = -0.4
            }
        }


{-| -}
headingM : TypeStyle msg
headingM =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 36
            , lineHeight = 40
            , letterSpacing = -0.4
            }
        , atLeast1024Wide =
            { fontSize = 30
            , lineHeight = 36
            , letterSpacing = -0.4
            }
        , atLeast768Wide =
            { fontSize = 26
            , lineHeight = 32
            , letterSpacing = -0.2
            }
        , default360 =
            { fontSize = 26
            , lineHeight = 32
            , letterSpacing = -0.2
            }
        }


{-| -}
headingS : TypeStyle msg
headingS =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 30
            , lineHeight = 36
            , letterSpacing = -0.4
            }
        , atLeast1024Wide =
            { fontSize = 26
            , lineHeight = 32
            , letterSpacing = -0.2
            }
        , atLeast768Wide =
            { fontSize = 22
            , lineHeight = 28
            , letterSpacing = -0.2
            }
        , default360 =
            { fontSize = 22
            , lineHeight = 28
            , letterSpacing = -0.2
            }
        }


{-| -}
headingXS : TypeStyle msg
headingXS =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 26
            , lineHeight = 32
            , letterSpacing = -0.2
            }
        , atLeast1024Wide =
            { fontSize = 22
            , lineHeight = 28
            , letterSpacing = -0.2
            }
        , atLeast768Wide =
            { fontSize = 18
            , lineHeight = 22
            , letterSpacing = -0.2
            }
        , default360 =
            { fontSize = 18
            , lineHeight = 22
            , letterSpacing = -0.2
            }
        }


{-| -}
headingXXS : TypeStyle msg
headingXXS =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Medium500
        }
        { atLeast1440Wide =
            { fontSize = 20
            , lineHeight = 24
            , letterSpacing = -0.2
            }
        , atLeast1024Wide =
            { fontSize = 18
            , lineHeight = 22
            , letterSpacing = -0.2
            }
        , atLeast768Wide =
            { fontSize = 16
            , lineHeight = 20
            , letterSpacing = -0.2
            }
        , default360 =
            { fontSize = 16
            , lineHeight = 20
            , letterSpacing = -0.2
            }
        }


{-| -}
leadL : TypeStyle msg
leadL =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Regular400
        }
        { atLeast1440Wide =
            { fontSize = 36
            , lineHeight = 52
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 30
            , lineHeight = 44
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 26
            , lineHeight = 38
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 26
            , lineHeight = 38
            , letterSpacing = 0
            }
        }


{-| -}
leadS : TypeStyle msg
leadS =
    typeStyle
        { fontFamily = AktivGrotesk
        , fontWeight = Regular400
        }
        { atLeast1440Wide =
            { fontSize = 30
            , lineHeight = 44
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 26
            , lineHeight = 38
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 22
            , lineHeight = 34
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 22
            , lineHeight = 34
            , letterSpacing = 0
            }
        }


{-| -}
bodyXL : TypeStylePair msg
bodyXL =
    typeStylePair
        AktivGrotesk
        { atLeast1440Wide =
            { fontSize = 24
            , lineHeight = 36
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 20
            , lineHeight = 32
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 18
            , lineHeight = 28
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 18
            , lineHeight = 28
            , letterSpacing = 0
            }
        }


{-| -}
bodyL : TypeStylePair msg
bodyL =
    typeStylePair
        AktivGrotesk
        { atLeast1440Wide =
            { fontSize = 20
            , lineHeight = 32
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 18
            , lineHeight = 28
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 16
            , lineHeight = 24
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 16
            , lineHeight = 24
            , letterSpacing = 0
            }
        }


{-| -}
bodyS : TypeStylePair msg
bodyS =
    typeStylePair
        AktivGrotesk
        { atLeast1440Wide =
            { fontSize = 18
            , lineHeight = 28
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 16
            , lineHeight = 24
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 14
            , lineHeight = 22
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 14
            , lineHeight = 22
            , letterSpacing = 0
            }
        }


{-| -}
noteL : TypeStylePair msg
noteL =
    typeStylePair
        AktivGrotesk
        { atLeast1440Wide =
            { fontSize = 16
            , lineHeight = 24
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 14
            , lineHeight = 22
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 12
            , lineHeight = 18
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 12
            , lineHeight = 18
            , letterSpacing = 0
            }
        }


{-| -}
noteS : TypeStylePair msg
noteS =
    typeStylePair
        AktivGrotesk
        { atLeast1440Wide =
            { fontSize = 14
            , lineHeight = 20
            , letterSpacing = 0
            }
        , atLeast1024Wide =
            { fontSize = 12
            , lineHeight = 18
            , letterSpacing = 0
            }
        , atLeast768Wide =
            { fontSize = 11
            , lineHeight = 16
            , letterSpacing = 0
            }
        , default360 =
            { fontSize = 11
            , lineHeight = 16
            , letterSpacing = 0
            }
        }



-- Helper functions


type FontFamily
    = AktivGrotesk
    | Merriweather


fontFamilyToString : FontFamily -> String
fontFamilyToString fontFamily =
    case fontFamily of
        AktivGrotesk ->
            "aktiv-grotesk"

        Merriweather ->
            "Merriweather"


type FontWeight
    = Medium500
    | Regular400
    | Light300


fontWeightToAttribute : FontWeight -> Attribute msg
fontWeightToAttribute fontWeight =
    case fontWeight of
        Medium500 ->
            Font.medium

        Regular400 ->
            Font.regular

        Light300 ->
            Font.light


styledAttributes : FontFamily -> FontWeight -> Int -> Int -> List (Attribute msg) -> List (Attribute msg)
styledAttributes fontFamily fontWeight fontSize lineHeight additionalAttributes =
    [ Font.family
        [ Font.typeface <| fontFamilyToString fontFamily
        ]
    , fontWeightToAttribute fontWeight
    , Font.size fontSize
    , Element.spacingXY 0 (lineHeight - fontSize)

    -- ^^^ Note that Elm UI thinks the concept of line-height in CSS is flawed.
    -- Our designs in Figma use line-height, so we convert those to Elm UI's spacing model.
    ]
        ++ additionalAttributes
