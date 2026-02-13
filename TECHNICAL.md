# Technical Documentation: Unitrack – The Intelligent Wealth OS

## 🛡️ Executive Summary

Unitrack is built as a highly-composable, service-oriented iOS application. The architecture prioritizes **separation of concerns**, ensuring that UI components are decoupled from business logic and networking protocols. This approach allows for rapid scaling, easier testing, and robust handling of complex real-time financial data.

---

## 🏗️ Deep-Dive Architecture

### 1. Presentation Layer (SwiftUI + Atomic Design)

We leverage SwiftUI’s declarative nature alongside a **Modular Component Architecture**.

- **Atomic Components**: UI elements are broken down into atoms (e.g., custom fonts, colors), molecules (e.g., `AssetCard`, `StatItem`), and organisms (e.g., `PositionsView`, `ChartContainer`). This ensures a dry (Don't Repeat Yourself) codebase.
- **State Management**: We use a mix of `@StateObject` for lifecycle-managed view models and `@EnvironmentObject` for global states like `SubscriptionManager`. This creates a unidirectional data flow that is easy to debug.
- **Fluid UX**: The application achieves a "60 FPS" native feel by offloading complex data transformations (like mapping backend snapshots to chart models) to background threads, ensuring the main thread remains responsive for animations.

### 2. Service-Oriented Architecture (SOA)

The logic of the application is encapsulated in a dedicated Service Layer. Each service is a single-responsibility unit:

- **PlaidService**: Manages the production-ready Plaid Link handshake. It handles link token retrieval, public-to-access-token exchange, and parses institution metadata using a robust `AnyCodable` wrapper to handle Plaid's flexible JSON schemas.
- **PortfolioService**: Acts as the data aggregator, fetching everything from top-level summaries to granular holdings and historical performance snapshots.
- **MarketService**: Provides high-performance search across thousands of traditional and digital assets, with intelligent caching of asset details.
- **AnalyticsService**: The "Brains" of the app. It consumes raw portfolio data to compute complex metrics like Geographic Exposure and the Unitrack Health Score.

### 3. Networking & Data Synchronization

A centralized, generic `HTTPClient` serves as the backbone for all external communication.

- **Type-Safe Networking**: Uses Swift Generics and `Codable` to ensure compile-time safety for all API requests and responses.
- **Error Propagation**: Implements a professional error-handling pipeline. The client maps raw URLSession errors into user-friendly `UnitrackError` types, which are then surfaced to the UI via an `ErrorOverlay` or Toast notification.
- **Token Management**: The `TokenManager` securely persists Bearer tokens, while the `HTTPClient` automatically injects them into requests that require authentication.

---

## 💰 RevenueCat Implementation: Monetization & Entitlements

Unitrack utilizes **RevenueCat** to manage subscriptions and gate-keep premium features. This implementation is designed for reliability and seamless user onboarding.

### The Subscription Manager

The `SubscriptionManager` (a singleton `@MainActor` class) manages the user's entitlement state globally.

- **Entitlement Gating**: Features like "Advanced Analytics" and "AI Advisory" checks the `subscriptionManager.isPremium` flag before rendering.
- **Implementation Strategy**:
  - **Cold Start**: The manager refreshes customer info upon app initialization.
  - **Live Updates**: It implements the `PurchasesDelegate` to react instantly to App Store transactions or renewals.
- **Logic Snippet**:
  ```swift
  private func updateEntitlements(_ info: CustomerInfo?) {
      // Entitlement ID is strictly matched to the RevenueCat Dashboard
      self.isPremium = info?.entitlements["Unitrack Pro"]?.isActive ?? false
  }
  ```

---

## 🔒 Security & Data Integrity

- **Stateless Handshakes**: Sensitive credentials (like Plaid Secret Keys) are never stored on the client. Our backend brokers all sensitive API calls, keeping the iOS client lightweight and secure.
- **Additivity in Models**: Our data models (e.g., `HoldingItem`, `Portfolio`) are built with custom initializers that support "Additive Defaults." This means new properties (like `currentPrice` or `costBasis`) can be added to the backend without breaking earlier versions of the client.
- **Plaid Metadata Handling**: We implemented a robust JSON mapping strategy to handle the diverse institution metadata returned by Plaid, ensuring the app remains stable regardless of the connecting bank's data quality.

---

## 🚀 Key Technical Highlights

- **Performance**: Simultaneous data fetching using `async let` in the `fetchData()` cycles for minimal loading times.
- **Maintainability**: A clean folder structure separating `Features`, `Networking`, `Models`, and `Managers` for high developer velocity.
- **Resilience**: A custom error-mapping extension that translates technical networking codes (like -1011) into actionable user guidance.
