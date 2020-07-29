# ios-Yelp Search+

##  General info
Building a simple iOS application that will ingest yelp buisness search API, displaying the search results in a collection view with the ability to tap into the full details.



## Technologies
Project is created with:
*Xcode (V. 11.6)
*supports ios 12..0 +



## Features
- Main View offers search bar that user can use to search in restaurants of their choice (utilizied the Business Search API from Yelp API )
- By default, when a search is performed, the search results are sorted in descending order. Sort Switch lets user switch between ascending/descending order. However, the sort state is not persisted for app relaunch.
- Also, if user allows Locations services, current latitude and longitude values are being sent as part of network request. However, if user denies the location services, default Location = Toronto is being used.
- Tapping into an searched Cell navigates the user to Detail View screen which displays the  image for the restaurant (if it exists) and also displays the name, Address of the restaurant selected.
- For fetching Reviews information, another API call for reviews is being made on detail screen  and the response is futher sorted based on its "time_created" to display the latest review on screen.
-  As part of the latest review, the user image and review text is being displayed in the detail Screen. In case of missing image, placeholder image from assets is being displayed for user reviews.
-  Appropriate error handling for missing data, no internet connection, server error, etc (Displays specific error message on the screen)
- Followed MVC design pattern to seperate model layer from view and the controller. It also helps prevent too much scattering of the code.
- Also the structure can be further scaled to include multiple network calls and include testcases (where we can mock the networkManager classes defined)
- Used extensions to seperate out the delegate/protocol implementation. so in Future if the Controllers become massive we can easily seperate out the Extensions in a seperate file and thus maintain the code for readability.
- Added reusable extensions that helps us tweak the standard library to fit in the requirements. Example: used UIViewController+Extension to display ActivityViewIndicator. which can be further add to any controllers.



## Third-Party Library Used
### SDWebImage

-Added it to the project using cocoapods 
- Experience using this framework previously

Why  SDWebImage ?
-since it provides hassle free  asynchronous image downloading with cache support
-it guarantee that the same URL won't be downloaded several times
-better cache management
-guarantee that main thread will never be blocked
-Performances!
