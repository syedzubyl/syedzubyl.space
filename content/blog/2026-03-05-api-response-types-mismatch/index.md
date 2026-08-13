+++
title = "When API Response Types Don't Match Your Flutter Model"
date = 2026-03-05
description = "Handling dynamic JSON, nullable fields, and defensive parsing in Dart when backend API contracts drift."

[taxonomies]
tags = ["API", "Flutter", "Dart"]
+++

### The Problem

A Flutter application was crashing on the profile screen with a cryptic error in the console:

```text
type 'int' is not a subtype of type 'bool?'
```

The app compiled perfectly, the API returned a 200 OK, but the JSON deserialization failed entirely, resulting in a red screen of death in debug mode (and a blank screen in production).

### Context

In Dart, type safety is strict. When you parse a JSON response, you typically map a `Map<String, dynamic>` into a strongly-typed Dart object. 

Our model looked like this:
```dart
class UserProfile {
  final String name;
  final bool? isPremium;

  UserProfile({required this.name, this.isPremium});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      isPremium: json['isPremium'],
    );
  }
}
```

### What I Tried

I checked the backend documentation (Swagger/OpenAPI). The documentation clearly stated that `isPremium` was a boolean. I assumed the issue was a null value since `isPremium` might not exist for legacy users, but I had already marked it as nullable (`bool?`).

### What Failed

Ignoring the type cast didn't work. The exception specifically complained about an `int`. 

### What Worked & Technical Explanation

I intercepted the raw HTTP response body before it hit the Dart parser.

```json
{
  "name": "Syed",
  "isPremium": 1
}
```

The backend developer had migrated the database, and the new database driver was serializing SQL `TINYINT(1)` boolean columns into `1` and `0` integers in the JSON payload, rather than `true` and `false`. 

Because `json['isPremium']` contained an integer `1`, Dart crashed when it implicitly tried to cast it to `bool?`.

To fix this, I implemented **defensive serialization**. Instead of trusting the API contract blindly, the Dart parser needs to handle potential type coercion gracefully:

```dart
factory UserProfile.fromJson(Map<String, dynamic> json) {
  
  // Defensive parsing function
  bool? parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  return UserProfile(
    name: json['name'] ?? 'Unknown',
    isPremium: parseBool(json['isPremium']),
  );
}
```

### Lessons Learned

1. **API Contracts Drift:** Backend implementations change, and serialization layers can inadvertently alter the types of JSON payloads (especially converting booleans to integers or numbers to strings).
2. **Dart is Unforgiving:** Unlike JavaScript, Dart will not automatically coerce `1` into `true`. You must handle the conversion explicitly.

### What I Would Do Differently

I will use code-generation tools like `json_serializable` or `freezed` with custom `JsonConverter` classes for primitive types. This abstracts away the boilerplate of defensive parsing and ensures the entire app handles API type mismatches consistently.
