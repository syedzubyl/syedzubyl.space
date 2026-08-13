+++
title = "Understanding Java Backend Development by Building Real Projects"
date = 2026-06-12
description = "Moving beyond syntax: How building real APIs teaches OOP, Dependency Injection, and architectural patterns in Java and Spring Boot."

[taxonomies]
tags = ["Java", "Spring Boot", "Backend"]
+++

### The Problem

Learning Java syntax is easy. Understanding how to build a production-grade backend system is hard. Many tutorials stop at creating a simple `HelloWorldController`, leaving developers confused about how to structure a large application, manage dependencies, and handle complex business logic.

### Context

When I started diving deep into Java and Spring Boot, I wanted to move past theoretical examples and understand the actual mechanics of a production backend. How do services communicate? How do we handle transactions? Where does business logic actually live?

### What I Tried

I initially tried to learn by reading textbooks on Design Patterns and Object-Oriented Programming (OOP) in isolation. I studied Singleton, Factory, and Strategy patterns.

### What Failed

While I understood the patterns conceptually, I had no idea when or why to use them in a real web server. The abstractions felt unnecessary. Writing an interface for a simple database query seemed like over-engineering when I could just write the logic directly in the controller.

### What Worked & Technical Explanation

The "aha" moment came when I stopped reading isolated examples and built a real REST API managing complex data relationships. 

Suddenly, the concepts clicked:

**1. Dependency Injection (DI)**
I finally understood why Spring's `@Autowired` (or constructor injection) is brilliant. Instead of a Service instantiating a specific Database class (tight coupling), the framework injects it. This meant I could swap my production database repository for a Mock repository during testing without changing a single line of business logic.

**2. Interfaces and Implementations**
I used an interface `PaymentProcessor`. In development, I injected a `MockPaymentProcessor`. In production, I injected a `StripePaymentProcessor`. The controller didn't care; it just called `paymentProcessor.charge()`. This is OOP in actual practice.

**3. Exception Handling**
Instead of scattering `try-catch` blocks everywhere, I utilized Spring's `@ControllerAdvice`. I threw custom exceptions (`UserNotFoundException`) deep in the service layer, and a global handler automatically translated them into formatted `404 Not Found` JSON responses. 

### Lessons Learned

You cannot learn enterprise architecture by writing isolated Java classes. You learn it by encountering the pain of tightly coupled code in a growing project, and then discovering how frameworks like Spring Boot use DI and interfaces to solve that exact pain.

### What I Would Do Differently

I would have focused on Test-Driven Development (TDD) from day one. Writing unit tests forces you to use Dependency Injection and interfaces properly. If a class is hard to test, it's usually because it's poorly architected. Testing is the ultimate feedback loop for good Java design.
