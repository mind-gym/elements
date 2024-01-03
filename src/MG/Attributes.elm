module MG.Attributes exposing
    ( transition
    , testIdentifier
    , onEnter
    )

{-|


# Style-specific

@docs style, transition


# Testing

@docs testIdentifier


# Events

@docs onEnter

-}

import Element exposing (Attribute, htmlAttribute)
import Html.Attributes as Attr
import Html.Events
import Json.Decode as Decode


{-| Add any property to any element in Elm-UI
-}
style : { property : String, value : String } -> Attribute msg
style { property, value } =
    htmlAttribute <| Attr.style property value


{-| Add standard transition to any element in Elm-UI. For use on elements where styles will change depending on some state change.
-}
transition : Attribute msg
transition =
    style
        { property = "transition"
        , value = "all 0.2s ease-in-out"
        }


{-| Add a data-test attribute to any element in Elm-UI. For use in e2e testing.
-}
testIdentifier : String -> Attribute msg
testIdentifier =
    let
        wantedChar ch =
            Char.isAlphaNum ch || ch == ':' || ch == '-' || ch == '@' || ch == '.' || ch == '<' || ch == '>'
    in
    htmlAttribute
        << Attr.attribute "data-test"
        << String.toLower
        << String.filter wantedChar
        << String.replace " " "-"
        << String.replace " - " "-"


{-| Add an onEnter event to any element in Elm-UI. Generally intended for use on input fields.
-}
onEnter : msg -> Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key - no action taken"
                    )
            )
        )
