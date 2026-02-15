# Unitrack: The Intelligent Wealth OS Story

## 🌟 The Inspiration: Fragmented Wealth

In an era where digital assets, global equities, and traditional banking coexist, the "Modern Investor" faces a unique problem: **fragmentation.** Most wealth management tools are either too simple (missing the nuances of geographic risk) or too complex (requiring manual data entry).

Unitrack was born out of a desire to build a "Command Center" for the next generation of wealth—one that feels as premium as it is intelligent. We didn't just want another tracker; we wanted an **OS for Wealth.**

## 🗺️ The Journey: From Concept to SwiftUI

Building Unitrack required a commitment to native performance. We chose **SwiftUI** to ensure the interface felt fluid and alive, adhering to **Atomic Design** principles.

### Phase 1: The Foundation

We spent the early days defining a robust **Service-Oriented Architecture (SOA)**. We knew that for Unitrack to be reliable, the UI had to be completely decoupled from the data. The creation of the `HTTPClient` and `TokenManager` laid the groundwork for a secure, professional-grade application.

### Phase 2: Intelligence & Integration

The "Magic" of Unitrack lies in its ability to turn raw data into insights. This led to the development of the **AnalyticsService**, where we implemented logic for:

- **Geographic Exposure**: Mapping portfolio holdings to global regions to visualize risk.
- **Unitrack Health Score**: A proprietary metric that aggregates diverse financial signals into a single, actionable number.

## 🛠️ The Challenges: Engineering Resilience

### The Plaid "Labyrinth"

Integrating **Plaid Link** in a production-ready environment was a significant hurdle. Handling the flexible JSON schemas and ensuring a stateless handshake between our backend and the iOS client required a custom `AnyCodable` wrapper and a resilient error-mapping system.

### Monetization with RevenueCat

Implementing **RevenueCat** was a strategic choice to ensure a seamless premium experience. The challenge was building a global `SubscriptionManager` that could handle entitlement gating across the entire app without introducing latency or brittle state management. We successfully implemented a `@MainActor` singleton that keeps the user's "Pro" status synced in real-time.

## 🏆 Key Accomplishments

- **60 FPS Performance**: Achieved by offloading heavy data mapping and transformations to background threads.
- **Unified Data Model**: A standard `HoldingItem` model that supports both traditional stocks and emerging digital assets.
- **Zero-Trust Security**: No sensitive banking credentials ever hit the client-side storage; everything is brokered via secure handshakes.

## 🧠 Learnings: Beyond the Code

The greatest lesson from Unitrack was the importance of **Composability.** By breaking the dashboard into small, reusable components, we were able to iterate rapidly on the UX without breaking the underlying logic.

Unitrack isn't just a finished product; it's a testament to how modern architecture and thoughtful design can simplify the complexity of global finance.

---

_Built with ❤️ for the future of wealth._
