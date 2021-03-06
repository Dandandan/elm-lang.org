module Website.Skeleton (skeleton, skeleton', homeSkeleton, installButtons, bigLogo) where

import Website.ColorScheme as C
import Graphics.Input as Input

skeleton : (Int -> Element) -> (Int,Int) -> Element
skeleton = flexSkeleton True 526

skeleton' : Int -> (Int -> Element) -> (Int,Int) -> Element
skeleton' = flexSkeleton True

homeSkeleton : (Int -> Element) -> (Int,Int) -> Element
homeSkeleton = flexSkeleton False 526

topBarHeight = 42
topBarPadding = 2
footerHeight = 120

extraHeight = topBarHeight + topBarPadding + footerHeight

flexSkeleton : Bool -> Int -> (Int -> Element) -> (Int,Int) -> Element
flexSkeleton isNormal inner bodyFunc (w,h) =
    let content = bodyFunc (min inner w) in
    color C.lightGrey <|
    flow down [ topBar isNormal inner w
              , container w (max (h-extraHeight) (heightOf content)) midTop content
              , container w footerHeight midBottom . flow down <|
                [ container w 2 middle . color C.mediumGrey <| spacer (inner+80) 1
                , container w 50 middle <| centered footerWords
                ]
              ]

topBar isNormal inner w =
    let leftWidth = inner - sum (map widthOf tabs)
        left = if isNormal then logo leftWidth else spacer leftWidth 30
    in  flow down
        [ container w topBarHeight middle . flow right <| left :: tabs
        , container w topBarPadding midTop <| color C.mediumGrey (spacer (inner+80) 1)
        ]

logo w =
    let name = leftAligned . Text.height 24 <| toText "elm" in
    container w topBarHeight midLeft . link "/" <|
    flow right [ image 30 30 "/logo.png"
               , spacer 4 30
               , container (widthOf name) 30 middle name
               ]

bigLogo =
    let name = leftAligned . Text.height 60 <| toText "elm" in
    flow right [ image 80 80 "/logo.png"
               , spacer 10 80
               , container (widthOf name) 80 middle name
               ]

tabs = map tab paths

paths =
  [ ("Learn"    , "/Learn.elm")
  , ("Examples" , "/Examples.elm")
  , ("Libraries", "/Libraries.elm")
  , ("Install"  , "/Install.elm")
  ]

tab (name, href) =
    let words = leftAligned . Text.link href <| toText name
    in  container (widthOf words + 20) topBarHeight midRight words

footerWords =
  let wordLink words1 href words2 words3 =
          toText words1 ++ Text.link href (toText words2) ++ toText words3
  in
     Text.color (rgb 145 145 145) <|
       wordLink "written in Elm and " "https://github.com/evancz/elm-lang.org" "open source" "" ++
       wordLink " / " "https://github.com/evancz" "Evan Czaplicki" " &copy;2011-14"

click : Input.Input ()
click = Input.input ()

installButtons w =
  let href = "https://github.com/evancz/Elm/blob/master/README.md#install"
  in  flow right [ container (w `div` 2) 80 middle <| link "/try" (button "Try")
                 , container (w `div` 2) 80 middle <| link href (button "Install") ]

box words c1 c2 =
    color c2 . container 180 50 middle .
    color c1 . container 178 48 middle .
    leftAligned . Text.height 30 . Text.color charcoal <| toText words

button words =
    Input.customButton click.handle ()
        (box words lightGrey grey)
        (box words lightGrey darkGrey)
        (box words grey blue)
