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

<!-- ## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://student.inso.tuwien.ac.at/mobile-app-software-engineering/ws22/track-a-team-10-ios.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://student.inso.tuwien.ac.at/mobile-app-software-engineering/ws22/track-a-team-10-ios/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thank you to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers. -->
