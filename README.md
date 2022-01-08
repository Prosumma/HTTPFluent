# HTTPFluent

HTTPFluent provides a fluent interface over HTTP, primarily designed to work with APIs. HTTPFluent supports three styles: callback, `async` (with Swift >= 5.5) and Combine.

## Integration

HTTPFluent is available only via Swift Package Manager.

## Usage

HTTPFluent is extremely intuitive to use, so a few examples will suffice:

```swift
let id = 2349713
let jwt = "xyz123"

let request = URLClient(url: "https://myapi.com")
  .path("user", id)
  .authorization(bearer: jwt)
  .post(json: User(name: "Don Quixote"))

// Callback style
request.receive(json: User.self) { result in
  do {
    let user = try result.get()
  } catch {
    // Oops, no user
  }
}

// Async style
let user = try await request.receive(json: User.self)

// Combine style
request.receivePublisher(json: User.self)
  .sink { completion in
    // Handle completion
  } receiveValue: { user in
    // Do something with user
  }
  .store(in: &cancellables)
```

HTTPFluent can also be used to generate a `URLRequest` without invoking it.

```swift
let urlRequest = URLClient(url: "https://myapi.com")
  .path("user", id)
  .authorization(bearer: jwt)
  .put(data: data) // Here we put raw data instead of JSON.
  .request
```

HTTPFluent uses immutable state. Each step in the chain to build the `URLRequest` copies a `URLRequestBuilder` struct. All operations are thus additive, encouraging reuse.

```swift
// Set up the shared information about the request.
let fluent = URLClient(url: "https://myapi.com")
  .authorization(bearer: jwt)
  .path("user")

// This adds the value of id as a path element, so the result is
// the path /user/123 or whatever the value of id is.
let postWithId = fluent.path(id).post(json: User.self)
let user = try await postWithId.receive(json: User.self)
```