# Weather App

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/abhandary/jpm/blob/main/demo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## XCode version used

* 14.2 (14C18)

## To run

* Run directly from XCode, doesn't need pods

## Focus Areas and problems I was looking to solve

**Modularization & Inter Module Communication**
* Consistent use of completion handlers and dispatch queues to enable inter module communications that require awaiting of results. 
* Use of Combine as glue between View Model and View layer.
* Adhering to SOLID principles with each module having a single reponsibility. Use of protocols for service layer modules to enable dependency injection, LSP, interface segregation and dependency-inversion, this also supports use of mocks for unit testing.
* Layering of the app using MVVM architecture style with a separate service layer.
* Use of immutable data models to pass data around, to prevent any unexpected behavior. Mapping the network response data model to a data model that's suited for the UI to make it easier for the UI to be consume it.
* Use of a Repository, this enables abstraction of source of truth. Repo then can then fetch from Network or a local data store as needed.
* The architecture enables user and location events to flow from UI or business layers through the service layer to the source of truth and enables streaming of data back from the source of truth to the UI layer, enabling unidirectional flow of data. Combine is currently not used as glue between the repo and VM, this can be easily done to support true streaming of state. 

**UI**
* UI is made adaptive by use of stack views in both the SwiftUI and UIKit weather cards.
* Using SwiftUI and UIKit based cards just for demonstration purposes.

## Some things you I would have liked to do if I had more time. 
* Better handling of the case where there is a last stored search and user has also granted location based search. Currently location based search takes precedence, however we may want the last stored search to take precedence for such cases.
* Adding more unit tests to cover all APIs and positive and negative test cases of the service layer modules. 
* Adjusting the date time for the city's timezone. e.g. Sunrise and sunset shows in user's current time zone instead of the
timezone of the city.
* Exploring using SwiftUI for the list view. I have used SwiftUI for this demo app I had written earlier to render a list view - https://github.com/abhandary/bookstore. 
* Use of Combine as glue between Service layer and View Model for streaming state back from repo to UI. This would also enable any updates made in the repo, initiated from elsewhere in the app (other screens for instance), to get published to the view model and update the weather view without use of mechanims such as delegates.
* Use of persistent asset store for assets, note that I used tried using approach in the demo app here - https://github.com/abhandary/employeedirectory, but didn't use this approach here. The implementation in the EmployeeDirectory demo app however needs work and needs to be revisited (has un-necessary synchronization for instance). 
* Explore use of Actors, Tasks and async, await for inter-module communication. Note that I used this approach in a demo app I had written earlier - https://github.com/abhandary/employeedirectory, however used dispatch queues and completion handlers in this project. 
 

## License

    Copyright [2023] [Akshay Bhandary]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
