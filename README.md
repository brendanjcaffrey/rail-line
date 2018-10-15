# Rail Line #

Rail Line is a simple iPhone app built to show CTA train arrivals.

## Building

You'll need to request a [CTA Train Tracker API Key](http://www.transitchicago.com/developers/ttkey.aspx). Once you have that, create `Rail Line/secrets.swift` and add this to it:

```swift
class Secrets {
    static let apiKey = "[YOUR KEY HERE]"
}
```

Then, run `carthage bootstrap` and build with Xcode.
