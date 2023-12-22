module MG.Viewport exposing
    ( Viewport, Width(..), PerBreakpoint, perBreakpoint
    , classify, classifyDefault360
    )

{-| How layouts work horizontally.

| Margin | Column | Gutter | Column | Gutter | ... | Gutter | Column | Margin |

There are two margins, on the extreme left and the extreme right.

There are gutters separating each column, so there is one fewer gutter
than there are columns.

Default360 has 6 columns (and 5 gutters). All other sizes have 12 columns
(and 11 gutters).

The margin widths and gutter widths are hard coded per viewport size.
The remaining width is divided equally between each column.

A component will span n columns (and therefore also the n-1 gutters between).


# Managing Viewport differences

@docs Viewport, Width, PerBreakpoint, perBreakpoint


# Classifying Viewport

@docs classify, classifyDefault360

-}

import Browser.Dom exposing (Viewport)
import Element exposing (..)


{-| Default is 360px wide, no reason to guarantee anything will work below this.
-}
type Width
    = Default360
    | AtLeast768Wide
    | AtLeast1024Wide
    | AtLeast1440Wide


{-| Helper to provide a different `a` for each viewport size.
-}
type alias PerBreakpoint a =
    { default360 : a
    , atLeast768Wide : a
    , atLeast1024Wide : a
    , atLeast1440Wide : a
    }


{-| Helper to retrieve a different `a` for each viewport size.
-}
perBreakpoint : PerBreakpoint a -> Viewport -> a
perBreakpoint values { size } =
    case size of
        Default360 ->
            values.default360

        AtLeast768Wide ->
            values.atLeast768Wide

        AtLeast1024Wide ->
            values.atLeast1024Wide

        AtLeast1440Wide ->
            values.atLeast1440Wide


{-| -}
type alias Viewport =
    { size : Width
    , height : Int
    , width : Int
    , marginWidth : Int
    , gutterWidth : Int
    , -- (spanningColumnsWidth n) returns the width of a span covering n columns,
      -- including the n-1 gutters inbetween
      spanningColumnsWidth : Int -> Int
    , -- to avoid rounding errors causing the widths to not add up correctly,
      -- calculate the width of one of your items as being contentWidth minus
      -- the width of everything else
      contentWidth : Int
    , columnCount : Int
    }


buildViewport :
    { width : Int
    , height : Int
    , size : Width
    , marginWidth : Int
    , gutterWidth : Int
    , columnCount : Int
    }
    -> Viewport
buildViewport { width, height, size, marginWidth, gutterWidth, columnCount } =
    let
        contentWidth =
            width - 2 * marginWidth

        totalColumnsWidth =
            contentWidth - (columnCount - 1) * gutterWidth

        spanningColumnsWidth count =
            totalColumnsWidth * count // columnCount + gutterWidth * (count - 1)
    in
    { size = size
    , height = height
    , width = width
    , marginWidth = marginWidth
    , gutterWidth = gutterWidth
    , contentWidth = contentWidth
    , spanningColumnsWidth = spanningColumnsWidth
    , columnCount = columnCount
    }


{-| -}
classify : { width : Int, height : Int } -> Viewport
classify { width, height } =
    let
        ( size, ( marginWidth, gutterWidth ), columnCount ) =
            if 1440 <= width then
                ( AtLeast1440Wide, ( 80, 40 ), 12 )

            else if 1024 <= width then
                ( AtLeast1024Wide, ( 60, 32 ), 12 )

            else if 768 <= width then
                ( AtLeast768Wide, ( 38, 28 ), 12 )

            else
                ( Default360, ( 20, 28 ), 6 )
    in
    buildViewport
        { size = size
        , height = height
        , width = width
        , marginWidth = marginWidth
        , gutterWidth = gutterWidth
        , columnCount = columnCount
        }


{-| Forces a viewport that always returns Default360 for its size.
-}
classifyDefault360 : { width : Int, height : Int } -> Viewport
classifyDefault360 { width, height } =
    buildViewport
        { size = Default360
        , height = height
        , width = width
        , marginWidth = 20
        , gutterWidth = 28
        , columnCount = 6
        }
