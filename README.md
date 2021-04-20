#  Pipelines Journey - Terraform + AWS Workshop https://academy.mastermnd.io/

You've been hired by a guy named Ralph. He just made $1,000,000 off of 🐶Dogecoin and he's ready to finally invest in his idea...which is ClubHouse, but they did it first, so now its called....TREEHOUSE. There currently is no actual app....but he has a team of devs building it now. These devs have planned the app out and have sent over an infrastructure diagram of what they are going to need to ensure this thing runs successfully. Ralph was a project manager before Dogecoin went to the moon, and he understands the value of automation. Your mission, should you choose to accept it is to deliver a codified infrastructure via terraform that satisfies the following requirements to Ralphs dev team.

# Time for Liftoff

![https://media.giphy.com/media/SQgbkziuGrNxS/giphy.gif](https://media.giphy.com/media/SQgbkziuGrNxS/giphy.gif)

# Infrastructure

- [ ]  This code will need to handle 3 different environments
    - [ ]  development
    - [ ]  staging
    - [ ]  production
- [ ]  Create Monthly budget to keep costs in check
    - [ ]  $1000 a month
- [ ]  We'll need some servers to do the main processing and enable voice features. We'll need the following:
    - [ ]  development
        - [ ]  1 t2.micro
        - [ ]  amazon linux
        - [ ]  tagged appropriately
        - [ ]  ipaddress output
    - [ ]  staging:
        - [ ]  2 t2.micro
        - [ ]  amazon linux
        - [ ]  tagged appropriately
        - [ ]  ipaddress output
    - [ ]  production:
        - [ ]  4 t2.micro
        - [ ]  amazon linux
        - [ ]  tagged appropriately
        - [ ]  ipaddress output

- [ ]  S3 Bucket for static hosting, and for assets
    - [ ]  dev
        - [ ]  static
        - [ ]  assets
    - [ ]  stage
        - [ ]  static
        - [ ]  assets
    - [ ]  prod
        - [ ]  static
        - [ ]  assets
- [ ]  Create a DyanmoDB table that is going to save data about rooms with the following attributes
    - [ ]  hash_key → RoomID(snumber)
    - [ ]  range key → RoomTopicTitle(string)
- [ ]  Bonus: Set S3 as backend
