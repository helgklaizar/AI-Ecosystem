# Uikit Guidelines Coding Standards

This skill provides language, framework, and tooling rules.

you are an expert in coding with swift, iOS, UIKit. you always write maintainable code and clean code.
focus on latest documentation and features.
your descriptions should be short and concise.
don't remove any comments.


UIKit UI Design Principles:
1. Auto Layout: Implement responsive layouts using SnapKit only (avoid NSLayoutConstraint for better readability), support Dynamic Type and Safe Area
2. Programmatic UI: Avoid Storyboards/XIBs, implement all UI components directly in code (UIView, UIButton, UITableViewCell). Use view composition and custom view subclasses for reusability
3. UI Components must not directly access models or DTOs. Use ViewController, Factory, or Builder patterns following OOP/MVC/MVVM principles. Below are good and bad practice examples:

good practice:
```swift
let user = User(name: "Alice", email: "john@example.com")
let factory = UserFactory()
/// This way UserView doesn't access User model directly, following Apple's MVC principles
let userView = factory.createUserView(user: user)
```

bad practice:
```swift
let user = User(name: "Alice", email: "john@example.com")
/// This exposes UserView to User model, violating MVC principles
let userView = UserView(user: user)
```

4. UI components should pass events using closures, and the closure must pass 'self' as a parameter to allow external objects to identify the source component

```swift
class SampleView: UIView {
    var didTapButton: ((SampleView) -> Void)?
    private let button = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupUI() {
        // setup UI
    }

    @objc private func buttonTapped() {
        didTapButton?(self)
    }
}
```

# UIKit Guidelines .GEMINI.md Prompt File

Author: MoonAndEye

## What you can build
iOS Application Deployment - App Store distribution package for native iOS applications. Provides production-ready IPA bundle following Apple's submission guidelines. Implements required provisioning profiles, entitlements, and compliance measures for public release.


## Synopsis
Implement Auto Layout using SnapKit, create UI programmatically without using Storyboard/XIB, manage UI components using Factory/Builder patterns, implement standardized ViewModel, and use closure-based event handling mechanisms.


## Overview of .GEMINI.md prompt
The .GEMINI.md file provides a comprehensive guide for developing iOS applications using Swift and UIKit. It emphasizes writing maintainable and clean code by following the latest documentation and features. The guidelines focus on implementing responsive layouts using SnapKit, avoiding Storyboards/XIBs, and creating all UI components programmatically. It promotes the use of view composition and custom view subclasses for reusability.

The principles outlined in the file include:
1. Auto Layout: Use SnapKit for responsive layouts, support Dynamic Type and Safe Area.
2. Programmatic UI: Implement UI components directly in code, avoid Storyboards/XIBs.
3. MVC/MVVM Principles: UI components should not directly access models or DTOs. Use ViewController, Factory, or Builder patterns.
4. Event Handling: Pass events using closures, and ensure the closure passes 'self' as a parameter for external object identification.

By adhering to these guidelines, developers can create efficient, scalable, and maintainable iOS applications that follow best practices and Apple's MVC principles.




`🔄 **Context:** [Agent: Current] | [Skill: uikit-guidelines] | [Workflow: Current]`
