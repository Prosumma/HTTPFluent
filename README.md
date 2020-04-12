# HTTPFluent

HTTPFluent provides a fluent interface over HTTP, primarily designed to work with APIs.

## Fluent interface?

A fluent interface uses method chaining to perform some task or series of tasks, such as building an instance of a type or performing a series of actions. 

```swift
let client = HTTPClient(baseURL: "https://httpbin.org")
client.path("status/500").accept("application/json").decode(String.self).request { result 
  switch request {
  case .success(let string):
    print(string)
  case .failure(let error):
    print(error)
  }
}
```

This forms a sort of Domain Specific Language (DSL) for making HTTP requests.

## Usage

Usage is mostly obvious and intuitive, so we will cover only those things which might not be obvious. 

### Decoding

By default, HTTPFluent expects that the caller will want to work with a raw `Data` instance, e.g.,

```swift
client
  .path("/some/path")
  .request { result in
    if case let .success(data) = result {
      // Handle the data here
    }
  }
```

Usually, however, we want to have some other type instead, such as a `String` or better yet something `Decodable` from JSON. To achieve that, various overloads of the `decode` method may be used.

```swift
client.decode(json: [Order].self).request { result in
  if case .success(let orders) = result {
    // Do something with the orders
  }
}
```

Note that after `decode` has been used in the method chain, the `result` parameter of the callback instantly changes from `Result<Data, HTTPError>` to `Result<[Order], HTTPError>`.

### The `simple` method

When making an HTTP request, the actual underlying result is wrapped in Swift's `Result` type. This way, if the request fails, we have error information about why the request failed. Multiple examples have already been given above.

But sometimes we do not care why the request failed. We just want an instance of the returned type or `nil` if the request failed. To get this, add `simple` into the method chain.

```swift
client.decode(json: [Order].self).simple.request { orders in
  guard let orders = orders else {
    print("Failed to get the orders")
    return
  }
  // Do something with the orders
}
```

### Working with `Combine`

If compiled with an OS version that supports `Combine`, HTTPFluent supplies a publisher which may be used to consume the HTTP response instead of calling the `request` method.

```swift
client
  .decode(json: [Order].self)
  .publisher
  .sink(receiveCompletion: completionCallback, receiveValue: valueCallback)
```

The type of the `publisher` property is polymorphic and changes based on the type being decoded. In the above case, it is `AnyPublisher<[Order], HTTPError>`. It is recommended to use HTTPFluent's `decode` method _before_ using the `publisher` property, rather than using the `decode` method from `Combine`, because you will have to do slightly less work with the type system.

