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

----
## Set Up Instructions
1. Clone the repo
2. Switch to the test branch
3. Fetch and pull latest from remote test branch
4. If developing, checkout a new branch from test and switch to it.
5. Press the "Play" button on the top left of Xcode while also making sure its for the "iPhone 11 Pro Max" simulator.

----
## .gitignore
We have a gitignore to ignore meta files.
**Note:** If any meta files can still be pushed, contact Irinel Bandas to address it in the .gitignore file and don't make any pushes to test/master until it's addressed.

