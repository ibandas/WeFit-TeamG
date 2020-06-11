# WeFit-TeamG
----
## Contact Info
Irinel Bandas - irinelbandas2020@u.northwestern.edu

----
## Repository Organization

Master is our prod env branch.

Test is our test env branch.

All feature branches developed by developers will be cut from the latest test branch, and PR will then be opened to test branch. PRs will be merged on a weekly basis. If there are no issues on test, the test branch will then be merged into master/prod.

**Note for DEVS!!!:** Always make sure to cut your branches from test and only merge into test. Do not merge on your own without having other developers look at it.

----
## Prerequisites
1. Xcode 11.3.1
2. Firebase / Firestore
3. Mac OS
4. Facebook Account (Can only login with a facebook account)

----
## Set Up Instructions
1. Clone the repo
2. Switch to the master branch
3. Fetch and pull latest from remote master branch
4. If developing, checkout a new branch from test and switch to it.
5. Open the .xcworkspace and NOT the .xcodeproj (This is so all firebase pods are used properly).
6. Press the "Play" button on the top left of Xcode while also making sure its for the "iPhone 11 Pro Max" simulator.


----
## Debugging
1. Any errors might be able to be fixed with a simple command of "pod install" in the directory of the Podfile.
   This will ensure that all dependencies are installed correctly.
   
----
## Beta Test
1. Feel free to test the app on your iPhone by accessing beta through this link: https://testflight.apple.com/join/SlvYrevG
2. You can download our beta app from Testflight with the link above.

----
## .gitignore
We have a gitignore to ignore meta files.
**Note:** If any meta files can still be pushed, contact Irinel Bandas to address it in the .gitignore file and don't make any pushes to test/master until it's addressed.

