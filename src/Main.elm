module Main exposing (main)

import List exposing (foldl)
import Playground exposing (Computer, black, blue, circle, game, move, rectangle, red, rotate, square, words, zigzag)


main =
    Memory [] { x = 0, y = 0 } 0 |> game view update



-- MODEL


type alias Shell =
    { x : Float
    , y : Float
    , vx : Float
    , vy : Float
    }


shellRadious : Float
shellRadious =
    10.0


initialVelocityMultiplier : Float
initialVelocityMultiplier =
    1 / 55.0


gravityMultiplier =
    1 / 3500


type alias Target =
    { x : Float
    , y : Float
    }


targetSize =
    60.0


barrelLength : Float
barrelLength =
    80.0


type alias Memory =
    { shells : List Shell
    , target : Target
    , angle : Float
    }



-- UPDATE


update : Computer -> Memory -> Memory
update computer memory =
    let
        w =
            computer.screen.width

        b =
            computer.screen.bottom

        mouse =
            computer.mouse

        initialVelocity =
            sqrt (w ^ 2 + 4 * b ^ 2) * initialVelocityMultiplier
    in
    { shells =
        (if mouse.click then
            [ { x = 20 - w / 2 + barrelLength * cos memory.angle
              , y = 20 + b + barrelLength * sin memory.angle
              , vx = initialVelocity * cos memory.angle
              , vy = initialVelocity * sin memory.angle
              }
            ]

         else
            []
        )
            ++ List.map (updateShell computer) memory.shells
    , target =
        if
            memory.shells
                |> List.map (hit memory.target)
                |> foldl (||) False
        then
            { x = zigzag (-w / 2) (w / 2) 2 computer.time, y = zigzag -b b 2 computer.time }

        else
            memory.target
    , angle = atan2 (mouse.y - b) (mouse.x + w / 2)
    }


hit : Target -> Shell -> Bool
hit shell target =
    (shell.x - target.x) ^ 2 + (shell.y - target.y) ^ 2 < (shellRadious + targetSize) ^ 2


updateShell : Computer -> Shell -> Shell
updateShell computer shell =
    let
        w =
            computer.screen.width

        b =
            computer.screen.bottom

        gravity =
            sqrt (w ^ 2 + 4 * b ^ 2) * gravityMultiplier
    in
    { x = shell.x + shell.vx
    , y = shell.y + shell.vy
    , vx = shell.vx
    , vy = shell.vy - gravity
    }


view computer memory =
    let
        w =
            computer.screen.width

        b =
            computer.screen.bottom

        mouse =
            computer.mouse
    in
    List.map (viewShell computer) memory.shells
        ++ [ words blue <| "(x: " ++ String.fromFloat (mouse.x + w / 2) ++ ", y: " ++ String.fromFloat (mouse.y - b) ++ ")"
           , (words red <| String.fromFloat memory.angle) |> move 0 50
           , words black "クリックで発射" |> move 0 100
           , viewTarget computer memory.target
           , rectangle black 15 barrelLength
                |> rotate (((memory.angle / (2 * pi)) * 360) - 90.0)
                |> move (-w / 2 + 20 + barrelLength / 2 * cos memory.angle) (b + 20 + barrelLength / 2 * sin memory.angle)
           , circle black 20
                |> move (-w / 2 + 20) (b + 20)
           ]


viewShell _ shell =
    circle blue shellRadious
        |> move shell.x shell.y


viewTarget _ target =
    square red targetSize
        |> move target.x target.y
