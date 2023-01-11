# HistoWeather (Track A Team 10 iOS)

## Description

Histoweather is an app that has the mission to let you intuitively explore the history of our earth's weather development of the last 60 years. With an interactive slider that changes the app's gradient background color we would like to propose a fun-to-use approach of navigating through this data. The app also provides a more "classic" way of exploring the data by creating line graphs.

HistoWeather makes use of the Weather Forecast API and Historical Weather API by open-meteo.com.

## Installation

To install this app clone this repository and open it with XCode. You can then run it on a simulator or a real device.

This project uses SwiftLint.

## Support
For any questions about this project contact us via E-Mail:

Marcell Lanczos: e1209638@student.tuwien.ac.at

Milos Stojiljkovic: e11824483@student.tuwien.ac.at

## Roadmap

### First Milestone

- Implementing location finding with Geocoding API
- Implementing request to Weather Forecast API for current weather
- Parsing data obtained form requests
- Implementing UI for all views
- Stitching everything together

### Second Milestone
- Implementing requests for Historical Weather API
- Parsing data
- Implementing UI for all views
- Implementing change for measuring units for Historical Weather API and Weather Forecast API for current weather

## Issues

### Open Bugs & Tasks

#2 Current weather forecast for one location

#3 Show weather forecast for the next 7 days

#4 Show weather forecast for one location by date

#5 Comparing the weather data of two dates

#6 Showing climate/temperature changes between two dates with ambient color changes

#7 Setting C°/F°

#11 BUG: Changing units causes random color flashes & showing default weather data

#13 Control slider through real dates and show weather parameters

#16 BUG: SliderView - Background color is not accurate when changing to Fahrenheit

#17 BUG: SliderView - First Load of the screen shows default data

#18 Enable Caching in SliderView

#19 BUG: Localize Time displays

#20 BUG: Graph is not in line with brand colors

### Closed Issues

#1 Add location

#8 BUG: CurrentView content is cropped in landscape mode

#9 BUG: shown weather parameters have no units yet

#10 BUG: Refresh only works every second time

#12 Make gradient background reactive to current temperature

#14 Gradient background changes color by temperature

#15 BUG: Pull-to-Reload in ForecastView causes View to disappear


## Contributing

Because this is an ongoing student project for TU Vienna's MSE class, this codebase is not open for contributing yet. But we would be open for it in the future and let us now any feedback and ideas for this app.

Authors and acknowledgment

## APIs

1. [Weather Forecast](https://open-meteo.com/en/docs)
Weather Forecast API offers hourly forecast for the next 7 days. Great variety of Weather variables can be specified such as max, min temperature, wind speed, participation sum… The location is specified by altitude and longitude (geocode) which we obtain by using geocoding API.

2. [Historical Weather](https://open-meteo.com/en/docs/historical-weather-api)
Historical Weather API offers historical weather data dating back to 1959. Offer by the same service as Weather Forecast API it allows for specification of same weather variables. Resolution of data can be Hourly or Daily. Time interval for requested data can be specified, which can reduce number of calls need for our usage.

3. [Geocoding](https://open-meteo.com/en/docs/geocoding-api)
Geolocation API returns geocode for a specific location specified by name. It also supports fuzzy searching by specifying name query parameters with 3 or more characters. Geocode is required for use of Weather Forecast and Historical Weather APIs.
## Project status

This project is currently under development and very much in its beginning steps.

## App usage

Our application is designed to be navigated using the navigation bar located at the bottom of the screen. The navigation bar provides access to five distinct screens. Upon initial installation, users will be prompted to grant permission for the application to access their location data. If a user chooses not to grant this permission, they will be presented with the search view where they may manually enter a location. Once a location has been selected, the search view will be closed and the user will be presented with the current view.

### CurrentView
![CurrentView](/screenshots/CurrentView.png){width=30% height=30%}

The CurrentView has been implemented to furnish users with the most recent weather data for their selected location or their device's present location.

###  ForecastView
![ForecastView](/screenshots/ForecastView.png){width=30% height=30%}

The ForecastView is designed to present users with a forecast of temperature data for the next 7 days, allowing them to plan and make informed decisions accordingly.

###  GraphView
![GraphView](/screenshots/GraphView.png){width=30% height=30%}

In GraphView, users have the ability to compare the hourly data of two distinct days, dating as far back as 1959, utilizing a graphical representation for easy comparison.

###  SliderView
![SliderView](/screenshots/SliderView.png){width=30% height=30%}

The SliderView feature allows users to view the evolution of temperature at a specified location, dating as far back as 1959. The user has the capability to adjust the date range, while the background color of the display will adjust to correspond with the temperature being presented.

###  SearchView
![SearchView](/screenshots/SearchView.png){width=30% height=30%}

At any point in the use of the application, the user has the ability to navigate to the Search View to modify the location for which weather data is being presented. Additionally, the user has the option to switch back to viewing weather data for their current location.

In every view where weather data is displayed, the user has the capability to change the unit of temperature, with the selected unit being synced across all views and retained even upon relaunching the application.


