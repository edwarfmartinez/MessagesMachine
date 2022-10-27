
# MessagesMachine

iOS app for automated messaging. Program your automated messages including sending frequency time and receiver users, and the messages machine will do the job.

Concepts:

* Serverless
* Charts
* Protocols and delegates
* XCTest
* firebase-database
* firebase-authentication
* firebase-firestore
* MVC

## Architecture Diagram

![Screen Shot 2022-10-27 at 3 47 21 PM](https://user-images.githubusercontent.com/99278919/198394773-228004a8-4f36-496a-9417-cf14f79f4c25.png)

### 1. Register and Login

Let's register and log in with two users:

* one@test.com for the iPhone
* two@test.com for the iPad

![LoginMessagesMachine](https://user-images.githubusercontent.com/99278919/186968766-8a5702f7-9ea6-464e-ae7d-1aa4f4460474.gif)

### 2. Automated Messaging Configuration

* See how user one@test.com (iPhone) creates an automated message for user two@test.com (iPad):

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/99278919/198344643-b2769e71-6675-4155-a6d8-18e2d402d536.gif)


* See how user two@test.com (iPad) creates an automated message for user one@test.com (iPhone):

![ezgif com-gif-maker (15)](https://user-images.githubusercontent.com/99278919/198346972-702950f0-9b15-4846-ae81-b48de12b16db.gif)


### 3. Message Frequency

* See how user one@test.com (iPhone) changes the frequency of the message so that user two@test.com (iPad) receives more messages in less time:

![ezgif com-gif-maker (16)](https://user-images.githubusercontent.com/99278919/198351107-31221485-43a4-4a9c-bc94-77fde9797580.gif)


* See how user one@test.com (iPhone) deletes its automated message, created to stablish communication with user two@test.com (iPad), who immediately stops receiving inbox notifications:

![ezgif com-gif-maker (17)](https://user-images.githubusercontent.com/99278919/198386005-792f0178-049f-41b0-a126-c0d90ea5f8e1.gif)


### 4. Charts

This view shows a pie chart where the final user can see the number of sent and received messages grouped by category:

![Screen Shot 2022-10-27 at 3 10 18 PM](https://user-images.githubusercontent.com/99278919/198388391-b8329288-46e7-4d76-8fdb-2b65e2027919.png)
