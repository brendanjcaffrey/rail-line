# Rail Line

Rail Line is a simple iPhone app built to show CTA train arrivals.

## Building

You'll need to request a [CTA Train Tracker API Key](https://www.transitchicago.com/developers/traintrackerapply/). Once you have that, create `Rail Line/secrets.swift` and add this to it:

```swift
class Secrets {
    static let apiKey = "[YOUR KEY HERE]"
}
```

Then, ensure all swift packages are resolved and build with Xcode.
