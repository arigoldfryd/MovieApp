## Architecture

<img width="641" alt="architecture" src="https://github.com/arigoldfryd/MovieApp/assets/12650891/a8313bf4-0c49-4559-8848-4d94a92862d4">


There are four main folders:

1. Presentations
2. Entities
3. Services
4. Extensions

To explain briefly, the Extensions folder contains files where functionality was added to the existing system classes.

### Presentations

It can be said that Presentation is the first layer. In this folder, there are mainly two things:
* Views
* ViewModels

Inside, there's a folder for each application flow:
* Movie List
* Movie Detail
* Search

Before diving into each specific view, I want to mention `SubscribedMovies`. `SubscribedMovies` is an Environment Object that helps keep the list of movies updated across all screens to which the user has subscribed.

**Movie List**

The movie list is displayed using a view created in SwiftUI and a ViewModel.

* `ViewModel`: It's responsible for fetching the movies from the endpoint and mapping the models so the view doesn't have business logic.
* `View`: The view is just that, a view. Its goal is to display information. In some cases, it decides whether certain information should be displayed or not.

Why did I use SwiftUI?

SwiftUI simplifies the creation of views (for some cases, not all). In this case, SwiftUI makes it easy to create a vertical list with a horizontal one on top of it.

If I had done this with UIKit, I would have used a `UICollectionView` with a custom `UICollectionViewCompositionalLayout` to achieve both horizontal and vertical scrolling.

**Movie Detail**

This is the simplest view of all. It receives a `Movie` object and displays it. In this case, I chose to create it with UIKit. To make a SwiftUI view push a UIKit view, I had to use a `UIViewControllerRepresentable`.

This flow doesn't have a ViewModel because the `Movie` model already has all the necessary information, saving us from making a new endpoint call.

**Search**

The Search is very similar to the Movie List. It has a `ViewModel` and a `View`. One handles fetching the information, and the other displays it.

### Entities

Entities are the folder where all the models are located. There are three types of models.

1. `Response`: These are the endpoint responses without any modification. There are two: `MovieResponse` and `GenreResponse`.
2. `DTO`: There's only one DTO in the application, `MovieDTO`. The reason it exists is that there are some properties (like dates and image URLs) that need to go through some logic to be in the correct format for display.
3. `Model`: These are the models that viewers can access. They contain information as it should be displayed.

As mentioned earlier, the `ViewModel` is responsible for "mapping the models so that the view doesn't have business logic." It uses the `MovieMapper` to achieve that. The `MovieMapper` is responsible for mapping a DTO to a Model. The `ViewModel` uses it to convert `MovieDTO` to `Movie` for the view's use.

### Services

There are three services used to fetch information, and each service knows how to call a single endpoint.

* `DiscoveryService`: Fetches the list of movies using pagination.
* `GenreService`: Retrieves the list of movie genres.
* `SearchService`: Gets a list of movies that contain specific text in their title.

Within this folder, we introduce a new type of entity: the `Clients`. Basically, `Clients` are responsible for fetching external information for the application. There are two types:
1. `RemoteClients`: This client fetches information from remote sources (a.k.a APIs).
2. `LocalClients`: This client, in turn, retrieves information from local sources on the device. In this case, it's from `UserDefaults`.

## External Libraries

For this application, I've only used one external library: [Nuke](https://github.com/kean/Nuke) for caching downloaded images.

Why Nuke?
* It's easy to use.
* There's an active and continuous team working on it.
