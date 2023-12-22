module MG.Colours exposing
    ( colours
    , Gradient, gradients, backgroundGradient
    , externalColourDefinitions
    )

{-|


# Solid colours

@docs colours


# Gradients

@docs Gradient, gradients, backgroundGradient


# Using external colours

@docs externalColourDefinitions

-}

import Element exposing (Attr, Color, rgb255, rgba255)
import Element.Background as Background
import Html exposing (Html)
import Svg
import Svg.Attributes as SvgAt


{-| Colours used throughout MindGym's styleguide.
-}
colours :
    { transparent : Color
    , white : Color
    , gradientGreen : List Color
    , bone400 : Color
    , bone300 : Color
    , bone200 : Color
    , bone : Color
    , green800 : Color
    , green700 : Color
    , green600 : Color
    , green : Color
    , green400 : Color
    , green300 : Color
    , green200 : Color
    , green100 : Color
    , teal800 : Color
    , teal700 : Color
    , teal600 : Color
    , teal500 : Color
    , teal400 : Color
    , teal300 : Color
    , teal200 : Color
    , teal100 : Color
    , blue800 : Color
    , blue700 : Color
    , blue600 : Color
    , blue500 : Color
    , blue400 : Color
    , blue300 : Color
    , blue200 : Color
    , blue100 : Color
    , purple800 : Color
    , purple700 : Color
    , purple600 : Color
    , purple500 : Color
    , purple400 : Color
    , purple300 : Color
    , purple200 : Color
    , purple100 : Color
    , red800 : Color
    , red700 : Color
    , red600 : Color
    , red500 : Color
    , red400 : Color
    , red300 : Color
    , red200 : Color
    , red100 : Color
    , peach100 : Color
    , yellow800 : Color
    , yellow700 : Color
    , yellow600 : Color
    , yellow500 : Color
    , yellow400 : Color
    , yellow300 : Color
    , yellow200 : Color
    , yellow100 : Color
    , black : Color
    , black700 : Color
    , black600 : Color
    , black500 : Color
    , black400 : Color
    , black300 : Color
    , black200 : Color
    , black100 : Color
    , greyscale300 : Color
    }
colours =
    { transparent = rgba255 0 0 0 0
    , white = rgb255 0xFF 0xFF 0xFF
    , gradientGreen = [ rgb255 0x44 0xFB 0x44, rgb255 0x00 0xE2 0x00 ] -- green400 -> green

    -- Bones
    , bone400 = rgb255 0xD0 0xD0 0xC8
    , bone300 = rgb255 0xDC 0xDC 0xD5
    , bone200 = rgb255 0xE9 0xE9 0xE2
    , bone = rgb255 0xF5 0xF5 0xEF

    -- Greens
    , green800 = rgb255 0x00 0x55 0x00
    , green700 = rgb255 0x00 0x83 0x00
    , green600 = rgb255 0x00 0xAD 0x00
    , green = rgb255 0x00 0xE2 0x00
    , green400 = rgb255 0x44 0xFB 0x44
    , green300 = rgb255 0x64 0xFF 0x64
    , green200 = rgb255 0x8C 0xFF 0x8C
    , green100 = rgb255 0xBF 0xFF 0xB3

    -- Teals
    , teal800 = rgb255 0x00 0x54 0x48
    , teal700 = rgb255 0x00 0x72 0x62
    , teal600 = rgb255 0x00 0xA0 0x88
    , teal500 = rgb255 0x00 0xE3 0xB8
    , teal400 = rgb255 0x40 0xF6 0xCE
    , teal300 = rgb255 0x6E 0xF9 0xE2
    , teal200 = rgb255 0x8A 0xFC 0xE9
    , teal100 = rgb255 0xA5 0xFE 0xF1

    -- Blues
    , blue800 = rgb255 0x00 0x27 0x54
    , blue700 = rgb255 0x00 0x3A 0x7D
    , blue600 = rgb255 0x00 0x53 0xAE
    , blue500 = rgb255 0x00 0x76 0xE3
    , blue400 = rgb255 0x00 0x93 0xFF
    , blue300 = rgb255 0x00 0xB6 0xFF
    , blue200 = rgb255 0x00 0xD6 0xFF
    , blue100 = rgb255 0x9E 0xE9 0xFF

    -- Purples
    , purple800 = rgb255 0x4A 0x00 0x6E
    , purple700 = rgb255 0x6C 0x00 0xA0
    , purple600 = rgb255 0x99 0x00 0xE2
    , purple500 = rgb255 0xC3 0x00 0xFF
    , purple400 = rgb255 0xD7 0x40 0xFF
    , purple300 = rgb255 0xE7 0x79 0xFF
    , purple200 = rgb255 0xEF 0xA5 0xFF
    , purple100 = rgb255 0xF2 0xD2 0xFF

    -- Reds
    , red800 = rgb255 0x73 0x00 0x24
    , red700 = rgb255 0xA4 0x00 0x35
    , red600 = rgb255 0xD7 0x00 0x3C
    , red500 = rgb255 0xFF 0x00 0x64
    , red400 = rgb255 0xFF 0x4B 0x7D
    , red300 = rgb255 0xFF 0x78 0xA5
    , red200 = rgb255 0xFF 0xA5 0xC8
    , red100 = rgb255 0xFF 0xCD 0xE1

    -- Peaches
    , peach100 = rgba255 215 0 60 0.05

    -- Yellows
    , yellow800 = rgb255 0xF5 0x41 0x00
    , yellow700 = rgb255 0xFF 0x87 0x00
    , yellow600 = rgb255 0xFF 0xA1 0x00
    , yellow500 = rgb255 0xFF 0xC8 0x00
    , yellow400 = rgb255 0xFF 0xD5 0x3D
    , yellow300 = rgb255 0xFF 0xDF 0x6B
    , yellow200 = rgb255 0xFF 0xEA 0x9E
    , yellow100 = rgb255 0xFF 0xF4 0xCC

    -- Blacks
    , black = rgb255 0x12 0x12 0x12
    , black700 = rgb255 0x21 0x24 0x27
    , black600 = rgb255 0x43 0x43 0x4A
    , black500 = rgb255 0x69 0x69 0x73
    , black400 = rgb255 0x82 0x82 0x8C
    , black300 = rgb255 0x9E 0x9E 0xA8
    , black200 = rgb255 0xD0 0xD0 0xD6
    , black100 = rgb255 0xE6 0xE6 0xEA

    -- Greys
    , greyscale300 = rgb255 208 208 214
    }


{-|

    Define your gradient.
    ID must be globally unique in your HTML.
    Direction is degrees clockwise from 12 o'clock.

-}
type alias Gradient =
    { id : String
    , startColour : Color
    , endColour : Color
    , direction : Float
    }


gradientList : List Gradient
gradientList =
    [ gradients.rectangle436
    , gradients.rectangle437
    , gradients.rectangle438
    , gradients.green400green500
    ]


type alias GradientAttributes =
    { id : String, startColour : Color, endColour : Color, direction : Float }


{-| A record containing the different gradients available
-}
gradients :
    { rectangle436 : GradientAttributes
    , rectangle437 : GradientAttributes
    , rectangle438 : GradientAttributes
    , green400green500 : GradientAttributes
    }
gradients =
    { rectangle436 =
        { id = "mind-gym-rectangle436"
        , startColour = colours.green400
        , endColour = colours.green
        , direction = 140.18
        }
    , rectangle437 =
        { id = "mind-gym-rectangle437"
        , startColour = colours.green
        , endColour = colours.green600
        , direction = 140.18
        }
    , rectangle438 =
        { id = "mind-gym-rectangle438"
        , startColour = colours.green400
        , endColour = colours.green600
        , direction = 140.18
        }
    , green400green500 =
        { id = "mind-gym-green400green500"
        , startColour = colours.green400
        , endColour = colours.green -- what was "Green/500" is now just called Green in Figma
        , direction = 140.18
        }
    }


{-|

    Sets the background gradient of an element.

-}
backgroundGradient : Gradient -> Attr decorative msg
backgroundGradient { startColour, endColour, direction } =
    Background.gradient
        { angle = direction * pi / 180
        , steps = [ startColour, endColour ]
        }


{-| This exists to get around the fact that we can't use CSS gradients
-}
externalColourDefinitions : Html msg
externalColourDefinitions =
    Svg.svg
        [ SvgAt.style "position: fixed; top: -999px; left: -999px; bottom: -888px; right: -888px;" ]
        [ Svg.defs [] <|
            List.map
                (\{ id, startColour, endColour, direction } ->
                    Svg.linearGradient
                        [ SvgAt.id id
                        , SvgAt.gradientTransform (rotateRepr direction)
                        ]
                        [ Svg.stop
                            [ SvgAt.offset "0%"
                            , SvgAt.stopColor (rgbRepr startColour)
                            ]
                            []
                        , Svg.stop
                            [ SvgAt.offset "100%"
                            , SvgAt.stopColor (rgbRepr endColour)
                            ]
                            []
                        ]
                )
                gradientList
        ]


rotateRepr : Float -> String
rotateRepr angle =
    String.concat
        [ "rotate("

        -- we think the gradient starts off oriented differently as an SVG gradient
        -- than it would if it was a CSS gradient
        , String.fromFloat (angle - 90)
        , ")"
        ]


rgbRepr : Color -> String
rgbRepr colour =
    let
        { red, green, blue, alpha } =
            Element.toRgb colour

        str channel =
            (String.fromInt << round) (channel * 255)
    in
    String.concat
        [ "rgba("
        , str red
        , ","
        , str green
        , ","
        , str blue
        , ","
        , str alpha
        , ")"
        ]
