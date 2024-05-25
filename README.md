# README for Airplane Pollution Simulation Model

## Authors
- **Assil Achour**
- **Alexandre Bailly**
- **Nael El Janati El Idrissi**
- **Djunice Lumban**
- **Jean-Michel Naud**
- **Florian Tigoulet**

## What is it?

This model simulates the pollution emitted by different types of airplanes flying between various cities in France. It tracks the fuel consumption, gas emissions, and the impact on city pollution levels.

## How it works

### Agents
- **Airplanes:** Represent different types of airplanes with specific attributes such as fuel consumption, departure and arrival cities, gas emitted, plane type, arrival coordinates, total flight time, and departure time.
- **Circles:** Represent cities with attributes like city name and gas counter.

### Globals
- `total-gas-emitted`: Total pollution emitted by all airplanes.
- `plane-counts`: Number of airplanes of each type.
- `city-coordinates`: Coordinates for each city.
- `max-planes-flying`: Maximum number of airplanes flying simultaneously.
- `city-names`: Names of the cities.
- `selected-departure-cities1`, `selected-departure-cities2`, `selected-departure-cities3`, `selected-departure-cities4`: Selected departure cities for each plane type.
- `selected-arrival-cities1`, `selected-arrival-cities2`, `selected-arrival-cities3`, `selected-arrival-cities4`: Selected arrival cities for each plane type.
- `report-departure-cities1`, `report-departure-cities2`, `report-departure-cities3`, `report-departure-cities4`: Report of departure cities for each plane type.
- `report-arrival-cities1`, `report-arrival-cities2`, `report-arrival-cities3`, `report-arrival-cities4`: Report of arrival cities for each plane type.
- `departure-delay`: Delay between airplane departures.
- `total-gas-emitted-type1`, `total-gas-emitted-type2`, `total-gas-emitted-type3`, `total-gas-emitted-type4`: Total pollution emitted by each type of airplane.
- `pollution-max-threshold`: Maximum pollution threshold for visual representation.

### Procedures

#### `setup-graph`
Initializes the pollution evolution plot.

#### `setup`
Initializes the simulation environment, including city coordinates, airplane counts, and visual settings.

#### `set-departure-city [city-name]`
Sets the departure city for the selected plane type, updating the global variables accordingly.

#### `set-arrival-city [city-name]`
Sets the arrival city for the selected plane type, updating the global variables accordingly.

#### `setup-map`
Imports the map of France for visual representation.

#### `go`
Main loop of the simulation. Manages airplane creation, movement, and pollution calculation.

#### `set-coordinates`
Sets the coordinates for departure and arrival cities for an airplane.

#### `do-plot`
Updates the pollution evolution plot.

## How to use it

1. **Setup**: Click the "Setup" button to initialize the simulation.
2. **Run**: Click the "Go" button to start the simulation.
3. **Adjust Sliders**: 
   - `count-plane-type1`: Adjust the number of airplanes of type 1 (Airbus A380).
   - `count-plane-type2`: Adjust the number of airplanes of type 2 (Boeing 707).
   - `count-plane-type3`: Adjust the number of airplanes of type 3 (Airbus A320).
   - `count-plane-type4`: Adjust the number of custom airplanes.
   - `time-on-floor`: Adjust the time spent on the ground between flights.
4. **Select Cities**: Use the buttons to set departure and arrival cities for each type of airplane.

## Things to notice

- Observe the pollution levels in different cities as airplanes take off and land.
- Notice the change in colors of the circles representing cities, indicating varying levels of pollution.

## Things to try

- Change the number of airplanes of each type and observe the impact on pollution levels.
- Select different combinations of departure and arrival cities and see how it affects the simulation.