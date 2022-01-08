# HTTPFluent

HTTPFluent provides a fluent interface over HTTP, primarily designed to work with APIs. HTTPFluent supports three styles: callback, `async` (with Swift >= 5.5) and Combine.

HTTPFluent is extremely intuitive to use, so a few examples will suffice:

```swift
let id = 2349713
let jwt = "xyz123"

let request = URLClient(url: "httpsZ://myapi.com")
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

// Combine style
request.receivePublisher(json: User.self)
```