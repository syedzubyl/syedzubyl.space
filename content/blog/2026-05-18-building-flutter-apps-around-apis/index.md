+++
title = "What I Learned Building Flutter Applications Around Real APIs"
date = 2026-05-18
description = "Practical lessons on state management, parsing, SQLite integration, and handling network failures in production Flutter apps."

[taxonomies]
tags = ["Flutter", "API", "Mobile"]
+++

### The Problem

Building a UI in Flutter is relatively straightforward. The real complexity begins when you connect that beautiful UI to a real-world, unpredictable REST API. Handling token expiration, offline states, local caching, and malformed JSON payloads quickly turns a simple app into a debugging nightmare.

### Context

While building a mobile LMS (Learning Management System) application in Flutter, I needed to fetch course catalogs, stream videos, and issue certificates. This required robust communication with a backend API while ensuring the app remained responsive even when the user's internet connection was spotty.

### What I Tried

I initially relied solely on the network. Every time a user opened a screen, a `FutureBuilder` would fire off an HTTP request and display a loading spinner until the data arrived.

### What Failed

1. **Poor UX:** Users stared at loading spinners constantly.
2. **Offline Experience:** If a user boarded a subway, the app became completely useless. It crashed or showed generic error screens.
3. **API Rate Limiting:** Spamming the backend with requests every time a user switched tabs was highly inefficient.

### What Worked & Technical Explanation

I shifted to a **Local-First Architecture** using SQLite (via the `sqflite` package).

Instead of the UI talking directly to the API, the UI only talks to the local SQLite database. A separate background synchronization engine talks to the API.

**The Flow:**
1. User opens the Course List screen.
2. The UI reads immediately from SQLite and displays cached data (instant load).
3. In the background, the app fires an API request to check for updates.
4. If the API returns new data, it updates the SQLite database.
5. The UI, listening to a stream from the database, automatically rebuilds with the fresh data.

**Handling API Failures:**
If an API request fails (e.g., user is offline, or the server returns a 500 error), the app simply logs the failure silently. The user is still looking at the cached data from SQLite and can continue interacting with the app.

### Lessons Learned

1. **Never trust the network.** The network will fail, it will be slow, and it will return unexpected data.
2. **Defensive Parsing:** Always wrap JSON parsing in try-catch blocks or use robust code-generation tools. One unexpected `null` field from the backend can crash the entire Flutter isolate.
3. **Local State is King:** For an app to feel fast and native, data must be available locally on the device the millisecond the screen renders.

### What I Would Do Differently

Instead of writing raw SQL queries for SQLite, I would adopt a higher-level reactive database like Isar or ObjectBox. They provide out-of-the-box stream capabilities that make tying local database updates directly to Flutter's reactive UI significantly easier than building custom `StreamControllers` over `sqflite`.
