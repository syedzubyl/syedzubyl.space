+++
title = "Designing a Reliable API Layer for a Mobile Application"
date = 2026-03-22
description = "Architectural lessons from building a scalable, fault-tolerant API layer in a mobile LMS application."

[taxonomies]
tags = ["API", "Architecture", "Mobile"]
+++

### The Problem

In the early stages of a mobile LMS application, HTTP requests were scattered directly inside UI widgets. Buttons would execute `http.get`, parse JSON inline, and call `setState`. This quickly became unmaintainable. Token expiration caused random crashes, error handling was inconsistent, and mocking data for tests was impossible.

### Context

A robust mobile application requires a strict separation of concerns. The UI should only care about *displaying* state, not fetching it. The networking layer must handle token injection, timeouts, retries, and error standardization before the data ever reaches the UI.

### What I Tried

I initially tried to create a single massive `ApiService` class that contained every single endpoint in the application. 

### What Failed

The `ApiService` file grew to thousands of lines. When multiple developers worked on different features (Authentication, Courses, User Profile), merge conflicts became a daily nightmare. Furthermore, handling token refreshes on a per-method basis resulted in heavily duplicated code.

### What Worked & Technical Explanation

I re-architected the API layer into a layered, modular system based on the Repository Pattern and Interceptors.

**1. The Base HTTP Client (The Interceptor Layer)**
Instead of using raw `http.Client`, I implemented a wrapper (using packages like `dio` or custom `http.BaseClient` implementations) that intercepts every request.
- **Request Interceptor:** Automatically injects the `Authorization: Bearer <token>` header from secure storage into every outgoing request.
- **Response Interceptor:** Global error handling. If a `401 Unauthorized` is returned, the interceptor pauses all outgoing requests, silently hits the refresh-token endpoint, updates secure storage, and retries the failed requests.

**2. Domain-Specific Repositories**
Instead of one massive API class, I created focused repositories:
- `AuthRepository`: Handles login, registration, and token management.
- `CourseRepository`: Fetches course lists and lesson details.
- `VideoRepository`: Manages video streaming URLs and playback telemetry.

**3. Standardized Result Wrappers**
Instead of throwing exceptions directly into the UI, repositories return a standardized Result type (often using Dart's `Either` pattern via the `fpdart` or `dartz` package).

```dart
Future<Either<ApiFailure, Course>> getCourseDetails(String id) async {
  try {
    final response = await _client.get('/courses/$id');
    return Right(Course.fromJson(response.data));
  } on DioError catch (e) {
    return Left(ApiFailure.fromDioError(e));
  }
}
```

### Lessons Learned

Separating the UI from the network layer is non-negotiable for production apps. The complexity of handling network latency, offline states, and token lifecycles must be encapsulated so the UI can remain declarative and clean.

### What I Would Do Differently

I would implement local caching (using SQLite) much earlier in the architecture. While the API layer was robust, relying entirely on network availability resulted in a poor experience on slow connections. Integrating a repository that checks local storage *before* hitting the API is the next logical step.
