
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

![Screen Shot 2022-10-27 at 10 03 12 AM](https://user-images.githubusercontent.com/99278919/198326833-440cb261-3603-4645-af8f-2ad23a00c15c.png)

### 1. Register and Login

Lets register and login two users:

* one@test.com for the iPhone
* two@test.com for the iPad

![LoginMessagesMachine](https://user-images.githubusercontent.com/99278919/186968766-8a5702f7-9ea6-464e-ae7d-1aa4f4460474.gif)

### 2. Automated messaging configuration

* See how user one@test.com (iPhone) creates an automated message for user two@test.com (iPad):

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/99278919/198344643-b2769e71-6675-4155-a6d8-18e2d402d536.gif)


* See how user two@test.com (iPad) creates an automated message for user one@test.com (iPhone):

![ezgif com-gif-maker (15)](https://user-images.githubusercontent.com/99278919/198346972-702950f0-9b15-4846-ae81-b48de12b16db.gif)


* See how user one@test.com (iPhone) changes the frequency of the message so that user two@test.com (iPad) receives more messages in less time:

![ezgif com-gif-maker (16)](https://user-images.githubusercontent.com/99278919/198351107-31221485-43a4-4a9c-bc94-77fde9797580.gif)


1. Message creation from the sender
2. Message verification from the receiver
3. Charts verification

![ezgif com-gif-maker (6)](https://user-images.githubusercontent.com/99278919/186969974-0a6b8ca5-73f4-44fa-b3fc-66be55d197c0.gif)
