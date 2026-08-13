+++
title = "Building a Mobile Backend Integration with React Native and TypeScript"
date = 2026-04-10
description = "Connecting a React Native mobile application to a robust Node.js backend using Azure SQL and external services."

[taxonomies]
tags = ["React Native", "TypeScript", "Node.js"]
+++

### The Problem

While working on the Mercantile Society Onboarding application, we needed to build a seamless onboarding flow that connected a React Native frontend with a Node.js backend, Azure SQL for relational data, and external services like Razorpay for payments and Appwrite/Supabase for authentication.

### Context

Cross-platform mobile applications often struggle with state management during complex, multi-step asynchronous flows. In an onboarding process, a user must authenticate, submit personal data, process a payment, and wait for external webhooks to confirm the transaction before proceeding to the final application state.

### What I Tried

I initially tried to manage the onboarding state purely in React Native's local component state (`useState`), chaining API calls sequentially on button presses. 

### What Failed

When a user's network connection dropped midway through a payment process, the local state was lost. When they reopened the app, they had to start the onboarding flow from the beginning, resulting in duplicate payment attempts and a frustrating user experience.

### What Worked & Technical Explanation

The solution required shifting the state management authority from the mobile client to the backend database.

**1. Database-Driven State Machine**
We designed the Azure SQL database to track an explicit `onboarding_status` for each user (e.g., `REGISTERED`, `DETAILS_SUBMITTED`, `PAYMENT_PENDING`, `COMPLETED`). 

**2. Idempotent API Endpoints**
The Node.js (TypeScript) backend was written to be idempotent. If the React Native app sent the "submit details" payload twice due to a network retry, the backend simply acknowledged the existing state rather than duplicating rows.

**3. Webhook Integration**
Instead of the mobile app waiting for a synchronous response from Razorpay, the mobile app initiated the payment and immediately polled a backend endpoint (or connected via WebSockets). The backend listened for Razorpay webhooks securely, updated the Azure SQL `onboarding_status`, and pushed the update to the client.

**4. React Native Architecture**
In TypeScript, we defined strict interfaces shared (conceptually) between the backend and frontend.

```typescript
// Shared Interface
interface OnboardingStatus {
  userId: string;
  step: 'REGISTERED' | 'PAYMENT_PENDING' | 'COMPLETED';
  isLocked: boolean;
}
```

The React Native application simply queried the `/api/user/status` endpoint on mount and rendered the corresponding screen based on the backend's source of truth.

### Lessons Learned

The mobile device is an unreliable environment. Never trust local memory to maintain critical business state (like payment processing steps). The backend database must act as the absolute source of truth, and the mobile app should function as a dumb terminal that simply renders whatever state the server returns.

### What I Would Do Differently

I would implement an offline-first queuing system using a tool like WatermelonDB or Redux Offline. While the backend state machine solved the data integrity problem, the UX still suffered when users hit dead zones. A proper queue would allow users to submit onboarding documents offline and seamlessly sync them when connectivity returned.
