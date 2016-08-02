# Project 1 - MetFlix

MetFlix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 20 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.
- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.

The following **optional** features are implemented:

- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.
- [ ] Tapping on a movie poster image shows the movie poster as full screen and zoomable.
- [ ] User can tap on a button to play the movie trailer.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/3iFCQqK.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

It was a bit confusing how to embed in two views (Table and Collection) under the same view controller at first. What's still troubles me is on storyboard it's very difficult to make changes to both views. Enve if one view is hidden, it's still showing on storyboard and makes it impossible to work on the other view.

The navigation cusomization is tricky, still couldn't get the background color working so I didn't check that box.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

