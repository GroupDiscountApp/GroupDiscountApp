# Group Discount App

GroupDiscount app is an iOS app to find people willing to avail group discount rates on various events.

Time spent: **** hours spent in total

## User Stories

The following **required** functionality is completed:

- [] User can create an account
- [] After user login, user sees a list of broadway shows available for group discounts
- [] User can search for a broadway show 
- [] Users can view details of the show
- [] User can find and make groups for going to a show and thereby can avail the group discount
- [] User can group chat with group memebers of the show


The following **optional** functionality is completed:

- [] User can send request to a friend and thereby maitain a friend list
- [] User can import contact from Facebook
- [] User can view the map for event venue

## Tables

1. UserInfo
  -UserID -Name -EmailAddress -Password -ProfilePhoto -PhoneNumber -ZipCode
2. EventDetails 
  -EventID -EventName -EventTime -OriPrice -GroupPrice -Description -Venue
3. EventTime
  -EventDate -EventTime
4. UserEvents
  -UserID -EventID
5. EventGroup
  -EventID  -Group
## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
I am unable to retweet and favorite a post correctly. The buttons and label count are updating, but it is not actually affect the user account in real time.

## License

Copyright [GroupDiscountApp] [2017]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
