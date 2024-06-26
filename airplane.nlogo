breed [airplanes airplane]
breed [circles circle]

; Define the properties for airplanes
airplanes-own [
  fuel-consumption
  departure-city
  arrival-city
  gas-emitted
  plane-type
  arrival-coordinates
  total-time
  departure-time
]

; Define the properties for circles
circles-own [
  city-represented
  gas-counter
]

; Define global variables
globals [
  total-gas-emitted
  plane-counts
  city-coordinates
  max-planes-flying
  city-names
  selected-departure-cities1
  selected-departure-cities2
  selected-departure-cities3
  selected-departure-cities4
  selected-arrival-cities1
  selected-arrival-cities2
  selected-arrival-cities3
  selected-arrival-cities4
  report-departure-cities1
  report-departure-cities2
  report-departure-cities3
  report-departure-cities4
  report-arrival-cities1
  report-arrival-cities2
  report-arrival-cities3
  report-arrival-cities4
  departure-delay
  total-gas-emitted-type1
  total-gas-emitted-type2
  total-gas-emitted-type3
  total-gas-emitted-type4
  pollution-max-threshold
]

; Initialize the pollution evolution graph
to setup-graph
  clear-all-plots
  set-current-plot "Pollution Evolution"
  plot 0
end

; Setup procedure to initialize the simulation
to setup
  clear-all ; Clear everything
  reset-ticks ; Reset the tick counter

  resize-world 0 400 0 400 ; Resize the world dimensions
  __change-topology false false ; Disable wrapping

  ; Initialize global variables
  set total-gas-emitted 0
  set max-planes-flying 10

  set total-gas-emitted-type1 0
  set total-gas-emitted-type2 0
  set total-gas-emitted-type3 0
  set total-gas-emitted-type4 0

  ; Set initial plane counts
  set plane-counts (list count-plane-type1 count-plane-type2 count-plane-type3 count-plane-type4)

  ; Define city coordinates
  set city-coordinates [
    ["Paris" 221 282]
    ["Lyon" 295 145]
    ["Marseille" 313 45]
    ["Toulouse" 193 54]
    ["Bordeaux" 137 104]
  ]

  set city-names ["Paris" "Lyon" "Marseille" "Toulouse" "Bordeaux"]

  ; Define initial departure and arrival cities for each plane type

  set selected-departure-cities1 ["Paris"]
  set selected-departure-cities2 ["Lyon"]
  set selected-departure-cities3 ["Marseille"]
  set selected-departure-cities4 ["Toulouse"]
  set selected-arrival-cities1 ["Bordeaux"]
  set selected-arrival-cities2 ["Bordeaux"]
  set selected-arrival-cities3 ["Paris"]
  set selected-arrival-cities4 ["Lyon"]
  set report-departure-cities1 ["Paris"]
  set report-departure-cities2 ["Lyon"]
  set report-departure-cities3 ["Marseille"]
  set report-departure-cities4 ["Toulouse"]
  set report-arrival-cities1 ["Bordeaux"]
  set report-arrival-cities2 ["Bordeaux"]
  set report-arrival-cities3 ["Paris"]
  set report-arrival-cities4 ["Lyon"]

  set departure-delay 0  ; Initialize the delay timer

  ; Set all patches to white color
  ask patches [
    set pcolor white
  ]
  setup-map ; Setup the map

  set pollution-max-threshold 4000000 ; Set maximum pollution threshold

  ; Create circles for each city and set their properties
  foreach city-coordinates [
    coordinates ->
    let city-name item 0 coordinates
    let x-cor item 1 coordinates
    let y-cor item 2 coordinates
    create-turtles 1 [
      setxy x-cor y-cor
      set shape "circle"
      set color blue
      set size 8
      set label city-name
    ]

    create-circles 1 [
      setxy x-cor y-cor
      set city-represented city-name
      set gas-counter 0
      set shape "circle"
      set size 20
      set color green
    ]
  ]

  setup-graph
end

; Set the selected departure city for the chosen plane type
to set-departure-city [city-name]
  let selected-departure-cities (ifelse-value (selected-plane-type = 1) [selected-departure-cities1]
                                           (selected-plane-type = 2) [selected-departure-cities2]
                                           (selected-plane-type = 3) [selected-departure-cities3]
                                           (selected-plane-type = 4) [selected-departure-cities4])
  let report-departure-cities (ifelse-value (selected-plane-type = 1) [report-departure-cities1]
                                           (selected-plane-type = 2) [report-departure-cities2]
                                           (selected-plane-type = 3) [report-departure-cities3]
                                           (selected-plane-type = 4) [report-departure-cities4])

  ifelse member? city-name selected-departure-cities [
    ; City is already selected, so remove it
    set selected-departure-cities remove city-name selected-departure-cities
    set report-departure-cities remove city-name report-departure-cities
  ] [
    ; City is not selected, so add it
    set selected-departure-cities lput city-name selected-departure-cities
    set report-departure-cities sentence report-departure-cities city-name
  ]

  ; Update the appropriate global variables
  if selected-plane-type = 1 [set selected-departure-cities1 selected-departure-cities set report-departure-cities1 report-departure-cities]
  if selected-plane-type = 2 [set selected-departure-cities2 selected-departure-cities set report-departure-cities2 report-departure-cities]
  if selected-plane-type = 3 [set selected-departure-cities3 selected-departure-cities set report-departure-cities3 report-departure-cities]
  if selected-plane-type = 4 [set selected-departure-cities4 selected-departure-cities set report-departure-cities4 report-departure-cities]

  display  ; Refresh the monitors
end

; Set the selected arrival city for the chosen plane type
to set-arrival-city [city-name]
  let selected-arrival-cities (ifelse-value (selected-plane-type = 1) [selected-arrival-cities1]
                                           (selected-plane-type = 2) [selected-arrival-cities2]
                                           (selected-plane-type = 3) [selected-arrival-cities3]
                                           (selected-plane-type = 4) [selected-arrival-cities4])
  let report-arrival-cities (ifelse-value (selected-plane-type = 1) [report-arrival-cities1]
                                         (selected-plane-type = 2) [report-arrival-cities2]
                                         (selected-plane-type = 3) [report-arrival-cities3]
                                         (selected-plane-type = 4) [report-arrival-cities4])

  ifelse member? city-name selected-arrival-cities [
    ; City is already selected, so remove it
    set selected-arrival-cities remove city-name selected-arrival-cities
    set report-arrival-cities remove city-name report-arrival-cities
  ] [
    ; City is not selected, so add it
    set selected-arrival-cities lput city-name selected-arrival-cities
    set report-arrival-cities sentence report-arrival-cities city-name
  ]

  ; Update the appropriate global variables
  if selected-plane-type = 1 [set selected-arrival-cities1 selected-arrival-cities set report-arrival-cities1 report-arrival-cities]
  if selected-plane-type = 2 [set selected-arrival-cities2 selected-arrival-cities set report-arrival-cities2 report-arrival-cities]
  if selected-plane-type = 3 [set selected-arrival-cities3 selected-arrival-cities set report-arrival-cities3 report-arrival-cities]
  if selected-plane-type = 4 [set selected-arrival-cities4 selected-arrival-cities set report-arrival-cities4 report-arrival-cities]

  display  ; Refresh the monitors
end


; Procedures to set specific cities for departure and arrival
to Paris
  set-departure-city "Paris"
end

to Lyon
  set-departure-city "Lyon"
end

to Marseille
  set-departure-city "Marseille"
end

to Toulouse
  set-departure-city "Toulouse"
end

to Bordeaux
  set-departure-city "Bordeaux"
end

to Arrival-City1
  set-arrival-city "Paris"
end

to Arrival-City2
  set-arrival-city "Lyon"
end

to Arrival-City3
  set-arrival-city "Marseille"
end

to Arrival-City4
  set-arrival-city "Bordeaux"
end

to Arrival-City5
  set-arrival-city "Toulouse"
end

; Setup the map by importing an image
to setup-map
  import-pcolors "map-france.png"
end

; Main procedure to run the simulation
to go
  ; Check if at least one departure and arrival city is selected for each plane type and they are different
  if
     (((count-plane-type1 != 0) and (length selected-departure-cities1 = 0 or length selected-arrival-cities1 = 0 or (length selected-departure-cities1 = 1 and length selected-arrival-cities1 = 1 and first selected-departure-cities1 = first selected-arrival-cities1))) or
      ((count-plane-type2 != 0) and (length selected-departure-cities2 = 0 or length selected-arrival-cities2 = 0 or (length selected-departure-cities2 = 1 and length selected-arrival-cities2 = 1 and first selected-departure-cities2 = first selected-arrival-cities2))) or
      ((count-plane-type3 != 0) and (length selected-departure-cities3 = 0 or length selected-arrival-cities3 = 0 or (length selected-departure-cities3 = 1 and length selected-arrival-cities3 = 1 and first selected-departure-cities3 = first selected-arrival-cities3))) or
      ((count-plane-type4 != 0) and (length selected-departure-cities4 = 0 or length selected-arrival-cities4 = 0 or (length selected-departure-cities4 = 1 and length selected-arrival-cities4 = 1 and first selected-departure-cities4 = first selected-arrival-cities4)))
  )
   [
    user-message "SELECT AT LEAST ONE DEPARTURE AND ARRIVAL CITY FOR EACH TYPE THAT ARE DIFFERENT"
    stop
  ]

  ; Decrease the departure delay timer if it is greater than 0
  if departure-delay > 0 [
    set departure-delay departure-delay - 1
  ]

  ; Create new airplanes if the departure delay is 0, fewer than max-planes-flying airplanes exist, and there are still planes to create
  if departure-delay = 0 and count airplanes < max-planes-flying and sum plane-counts > 0 [
    create-airplanes 1 [
      set shape "airplane"
      set size 15

      ; Determine the type of airplane randomly from available types
      set plane-type -1
      while [plane-type = -1 or item plane-type plane-counts = 0] [
        let random-type random 4
        if item random-type plane-counts > 0 [
          set plane-type random-type
        ]
      ]

      ; Set the color based on the plane type
      set color (ifelse-value (plane-type = 0) [red] (plane-type = 1) [green] (plane-type = 2) [yellow] (plane-type = 3) [pink])

      ; Set fuel consumption based on the plane type
      set fuel-consumption (ifelse-value (plane-type = 0) [11400] (plane-type = 1) [14400] (plane-type = 2) [2100] (plane-type = 3) [custom-fuel-consumption])
      ; Set departure and arrival cities based on the plane type
      set departure-city one-of (ifelse-value (plane-type = 0) [selected-departure-cities1] (ifelse-value (plane-type = 1) [selected-departure-cities2] (ifelse-value (plane-type = 2) [selected-departure-cities3] [selected-departure-cities4])))
      set arrival-city one-of (ifelse-value (plane-type = 0) [selected-arrival-cities1] (ifelse-value (plane-type = 1) [selected-arrival-cities2] (ifelse-value (plane-type = 2) [selected-arrival-cities3] [selected-arrival-cities4])))
      set-coordinates
      let target-xcor item 1 arrival-coordinates
      let target-ycor item 2 arrival-coordinates
      set total-time (distancexy target-xcor target-ycor) / 0.005 ; 0.005 pas par ticks
      set plane-counts replace-item plane-type plane-counts (item plane-type plane-counts - 1)
      set departure-time ticks ; Record the departure time

      ; Calculate initial gas emission based on time-on-floor
      let total-ticks-on-floor time-on-floor * 595
      let initial-gas-emission total-ticks-on-floor * 0.0747  ; Adding initial gas emission based on time spent on the floor: 595 ticks = 1 min, and 45 minutes = 2000 Kg of CO2 on floor
      set total-gas-emitted total-gas-emitted + initial-gas-emission
      if plane-type = 0 [ set total-gas-emitted-type1 total-gas-emitted-type1 + initial-gas-emission ]
      if plane-type = 1 [ set total-gas-emitted-type2 total-gas-emitted-type2 + initial-gas-emission ]
      if plane-type = 2 [ set total-gas-emitted-type3 total-gas-emitted-type3 + initial-gas-emission ]
      if plane-type = 3 [ set total-gas-emitted-type4 total-gas-emitted-type4 + initial-gas-emission ]
    ]

    set departure-delay time-on-floor * 200  ; Adjust this value to set the delay durations
  ]
  ; Move airplanes and calculate gas emissions
  ask airplanes [
    let target-xcor item 1 arrival-coordinates
    let target-ycor item 2 arrival-coordinates

    ; Calculate gas emitted based on the flight phase (takeoff, flight, landing)
    (ifelse ticks - departure-time < (departure-time + 5950) [ ; 595 ticks = 1 min so 5950 = 10 minutes
      set gas-emitted (2 * fuel-consumption * 3.1) / 35643 ; 1L de kérosène = 3.1 de C02, 2 décollage et 0.5 atterissage, total-time = distancexy ()
      let departure-city-name departure-city
      let airplane-gas-emitted gas-emitted
      ; Update gas counter and color for the departure city
      ask circles with [city-represented = departure-city-name] [
        set gas-counter gas-counter + airplane-gas-emitted
          ask circles [
          let gas-level gas-counter
          ifelse gas-level <= 0.2 * pollution-max-threshold [
            set color green
          ] [
            ifelse gas-level <= 0.4 * pollution-max-threshold [
              set color yellow
            ] [
              ifelse gas-level <= 0.6 * pollution-max-threshold [
                set color orange
              ] [
                ifelse gas-level <= 0.8 * pollution-max-threshold [
                  set color red
                ] [
                  set color black
                ]
              ]
            ]
          ]
        ]
      ]
      ]
      ticks - departure-time > (total-time - 5950) [
        ; Landing phase
        set gas-emitted (0.5 * fuel-consumption * 3.1) / 35643
        let arrival-city-name arrival-city
        let airplane-gas-emitted gas-emitted
        ; Update gas counter and color for the arrival city
        ask circles with [city-represented = arrival-city-name] [
          set gas-counter gas-counter + airplane-gas-emitted ; Increase gas counter for the arrival city
          let gas-level gas-counter
          ifelse gas-level <= 0.2 * pollution-max-threshold [
            set color green
          ] [
            ifelse gas-level <= 0.4 * pollution-max-threshold [
              set color yellow
            ] [
              ifelse gas-level <= 0.6 * pollution-max-threshold [
                set color orange
              ] [
                ifelse gas-level <= 0.8 * pollution-max-threshold [
                  set color red
                ] [
                  set color black
                ]
              ]
            ]
          ]
        ]
      ] [
        ; Flight phase
        set gas-emitted (fuel-consumption * 3.1) / 35643
    ])

    ; Update global gas emission counters
    set total-gas-emitted total-gas-emitted + gas-emitted
    if plane-type = 0 [ set total-gas-emitted-type1 total-gas-emitted-type1 + gas-emitted ]
    if plane-type = 1 [ set total-gas-emitted-type2 total-gas-emitted-type2 + gas-emitted ]
    if plane-type = 2 [ set total-gas-emitted-type3 total-gas-emitted-type3 + gas-emitted ]
    if plane-type = 3 [ set total-gas-emitted-type4 total-gas-emitted-type4 + gas-emitted ]

    ; Move airplane forward and die if it reaches the target coordinates
    ifelse distancexy target-xcor target-ycor < 1 [
      die ; Remove the airplane if it has reached its destination
    ] [
      fd 0.005 ; Move the airplane forward
    ]
  ]

  ; Update the pollution evolution plot
  do-plot
  ; Increment the tick counter
  tick
end

; Procedure to set coordinates for departure and arrival cities
to set-coordinates
  let departure-coordinates get-city-coordinates departure-city
  set arrival-coordinates get-arrival-coordinates
  setxy item 1 departure-coordinates item 2 departure-coordinates
  facexy item 1 arrival-coordinates item 2 arrival-coordinates
end

; Report procedure to get arrival coordinates
to-report get-arrival-coordinates
  report get-city-coordinates arrival-city
end

; Report procedure to get city coordinates by name
to-report get-city-coordinates [city]
  report one-of (filter [ coord -> item 0 coord = city ] city-coordinates)
end

; Procedure to update the pollution evolution plot
to do-plot
  set-current-plot "Pollution Evolution"
  set-current-plot-pen "total gas emission"
  plot total-gas-emitted

  set-current-plot-pen "type 1 gas emission"
  plot total-gas-emitted-type1

  set-current-plot-pen "type 2 gas emission"
  plot total-gas-emitted-type2

  set-current-plot-pen "type 3 gas emission"
  plot total-gas-emitted-type3

  set-current-plot-pen "type 4 gas emission"
  plot total-gas-emitted-type4
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
619
420
-1
-1
1.0
1
10
1
1
1
0
0
0
1
0
400
0
400
0
0
1
ticks
30.0

BUTTON
2
14
65
47
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
2
48
65
81
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
121
184
154
count-plane-type1
count-plane-type1
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
9
174
181
207
count-plane-type2
count-plane-type2
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
10
226
182
259
count-plane-type3
count-plane-type3
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
9
408
181
441
time-on-floor
time-on-floor
30
180
90.0
1
1
min
HORIZONTAL

BUTTON
75
519
138
552
NIL
Paris
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
37
491
187
509
Distance
12
0.0
1

TEXTBOX
38
586
170
604
Arrival
10
0.0
1

BUTTON
142
519
205
552
NIL
Lyon
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
207
520
293
553
NIL
Marseille
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
296
520
386
553
NIL
Bordeaux
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
392
520
481
553
NIL
Toulouse
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
74
579
137
612
Paris
Arrival-City1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
140
579
203
612
Lyon
Arrival-City2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
206
579
292
612
Marseille
Arrival-City3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
296
579
386
612
Bordeaux
Arrival-City4
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
393
578
482
611
Toulouse
Arrival-City5
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
25
527
84
545
Departure
10
0.0
1

TEXTBOX
14
102
164
120
Airbus A380 (red)
10
0.0
1

TEXTBOX
12
159
162
177
Boeing 707 (green)
10
0.0
1

TEXTBOX
13
212
163
230
Airbus A320 (yellow)
10
0.0
1

TEXTBOX
11
394
161
417
Time spent on floor
10
0.0
1

MONITOR
640
33
786
78
NIL
total-gas-emitted
17
1
11

PLOT
640
85
1158
418
Pollution Evolution
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"total gas emission" 1.0 0 -16777216 true "" ""
"type 1 gas emission" 1.0 0 -2674135 true "" ""
"type 2 gas emission" 1.0 0 -13840069 true "" ""
"type 3 gas emission" 1.0 0 -1184463 true "" ""
"type 4 gas emission" 1.0 0 -1664597 true "" ""

MONITOR
811
32
923
77
Airplanes in air
count airplanes
17
1
11

MONITOR
554
430
846
471
Departure Cities (Type 1)
report-departure-cities1
17
1
10

MONITOR
866
432
1159
473
Arrival Cities (Type 1)
report-arrival-cities1
17
1
10

SLIDER
9
280
182
313
count-plane-type4
count-plane-type4
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
9
353
190
386
custom-fuel-consumption
custom-fuel-consumption
0
50000
16900.0
100
1
NIL
HORIZONTAL

CHOOSER
396
429
534
474
selected-plane-type
selected-plane-type
1 2 3 4
1

MONITOR
555
492
846
533
Departure Cities (Type 2)
report-departure-cities2
17
1
10

MONITOR
553
552
845
593
Departure Cities (Type 3)
report-departure-cities3
17
1
10

MONITOR
553
609
844
650
Departure Cities (Type 4)
report-departure-cities4
17
1
10

MONITOR
867
493
1158
534
Arrival Cities (Type 2)
report-arrival-cities2
17
1
10

MONITOR
867
552
1159
593
Arrival Cities (Type 3)
report-arrival-cities3
17
1
10

MONITOR
866
609
1158
650
Arrival Cities (Type 4)
report-arrival-cities4
17
1
10

TEXTBOX
13
264
163
282
Custom airplane (pink)
10
0.0
1

TEXTBOX
645
13
795
31
Total CO2 emission (Kg)
10
0.0
1

TEXTBOX
73
13
223
85
TO LAUNCH\n1. Set slider\n2. Click Setup\n3. Choose departure/arrival cities\n4. Click GO\n
9
0.0
1

TEXTBOX
13
335
163
353
Custom fuel consumption (L/h)
10
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
