# Introduction
This coding exercise is used to determine my iOS coding skills.  The requirements are [listed](REQUIREMENTS.md).
# Requirements
The requirements are as follows:

* XCode 10
* CocoaPods 1.7.0
* An active iOS development account - if you would like to run the project on an actual hardware device

# Notes
I am using a preliminary view when requesting location permissions.  The reason for using the preliminary view is twofold.  

1. Once you request location permissions from Apple, the user will not be presented with the screen agan.  they are required to change their settings.
2. If the user rejects loction permissions, this view allows the app to open the settings directly and des not require the user to search thru the settings to make changes.

I am using RxCoreLocation to provide reactive programming when interacting with CoreLocation.  This makes location updates and changes in permissions easier and more straightforward than using delegates.

I was using RxCocoa to provide table updates, but pulled that option out when there was a problem I was having some difficulty overcoming.  I could overcome the problem given time, but time is of the essence for this code review.  I changed the project to use delegates for table display and interactions.

The problem I encountered using RxCocoa for the table is:

There are two different API calls required.  One call for a group of two known locations and the other call using location information.  When combining the results for the two calls, RxCocoa was creating two table sections.  I was not able, in a timely manner, to combine the results into a single Observable without the table sections.  There were several options I attempted, but the results were the same.  I had already used quite a bit of time and was not able, due to time, to implement RxDataSources.  If you would like to review where I was in the process, please review the branch `corelocation`.

If this issue occurred in practice, I would discuss the issue with the tema leader and come up with the appropriate resolution at that time.
