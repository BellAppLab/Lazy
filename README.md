# Lazy
_When `lazy var` doesn't cut it, have a truly Lazy variable in Swift._
_v0.2.1_

So you declared a `lazy var` in Swift thinking it would behave like lazily instantiated variables in good ol' Objective-C. You thought you would set them to `nil` and they would reconstruct themselves later on when needed.

You poor thing.

[They don't](https://stackoverflow.com/a/40847994).

So why not bring that awesomeness back to Swift in a very lightweight way?

## Requirements

* Xcode 8.0+
* Swift 3.2+

## Usage

Declare your `Lazy` variable in one of the three ways provided:

**Suggestion**: for the best results, use `let` when declaring your `Lazy` variables.

```swift
class TestClass
{
    let lazyString = §{
        return "testString"
    }

    let lazyDouble: Lazy<Double> = Lazy {
        return 0.0
    }

    let lazyArray = Lazy {
        return ["one", "two", "three"]
    }
}
```

Access your variable:

```swift
let testObject = TestClass()
print(testObject.lazyString§) //prints out "testString"
```

Set your variable to `nil` (or change its value):

```swift
let testObject = TestClass()
testObject.lazyDouble §= nil
```

## Operators

* `§`
    * "Unwraps" a `Lazy` variable
* `§=`
    * Assigns a new value to be returned by your `Lazy` variable
* `§{}`
    * Shorthand contructor for a `Lazy` variable
    
## Notes

For the best results, use `let` when declaring your `Lazy` variables.

Also, make sure to use `[weak self]` or `[unowned self]` if capturing `self` in a `Lazy` variable's constructor.

## Installation

### Cocoapods

Because of [this](http://stackoverflow.com/questions/39637123/cocoapods-app-xcworkspace-does-not-exists), I've dropped support for Cocoapods on this repo. I cannot have production code rely on a dependency manager that breaks this badly.

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Lazy using git submodules:

```
cd toYourProjectsFolder
git submodule add -b submodule --name Lazy https://github.com/BellAppLab/Lazy.git
```

Then, navigate to the new Lazy folder and drag the `Source` folder into your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

## License

Lazy is available under the MIT license. See the LICENSE file for more info.
