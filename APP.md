# iOS SwiftUI Portfolio Tracker - Development Brief (Updated with Plaid)

**App Name:** Portfolio Nexus  
**Platform:** iOS (SwiftUI)  
**Scope:** UI/Frontend implementation with Plaid integration architecture

---

## Project Overview

Build a unified investment portfolio tracking app that centralizes diverse investments (stocks, crypto, precious metals, real estate, fixed income) into a single dashboard. Uses **Plaid** for automatic bank and brokerage account connections, with manual entry fallback for unsupported assets.

---

## Architecture & Tech Stack

### Frontend

- **Framework:** SwiftUI (iOS 16+ minimum)
- **State Management:** Swift Concurrency (async/await), Combine for reactive updates
- **Charts:** Swift Charts framework for native visualizations
- **Data Persistence:** SwiftData or Core Data for local storage
- **Networking:** URLSession with async/await for API calls

### Third-Party SDKs

- **Plaid Link SDK:** `plaid/plaid-link-ios` via SPM
  - Handles OAuth flows for 12,000+ financial institutions
  - Supports investment accounts, bank accounts, crypto exchanges
  - Returns access tokens for backend API calls
- **RevenueCat SDK:** `revenuecat/purchases-ios` via SPM (paywall/subscriptions)

### Monetization (UI Only - Integration Later)

- Build paywall UI, subscription screens, and entitlement gates (mock data for now)

---

## App Structure (Updated)

### Navigation Architecture

```
TabView (Bottom Navigation)
├── Dashboard (Home)
├── Accounts (Plaid Connections + Manual Assets)
├── Analytics (Premium Feature)
└── Settings
```

**Key Change:** "Assets" tab renamed to **"Accounts"** to reflect connected accounts vs. individual assets.

---

## 1. Dashboard (Home Screen)

**Purpose:** Single-glance portfolio overview with aggregated data from Plaid + manual entries

### UI Components

**Header Section:**

- Total portfolio value (large, bold font)
- 24h change (% and $ with color coding: green/red)
- Last sync timestamp with Plaid logo badge
- Manual refresh button (pulls latest data from Plaid API)

**Portfolio Allocation Chart:**

- Pie chart showing asset distribution by category
- Categories: Stocks, Crypto, Precious Metals, Real Estate, Fixed Income, Cash
- **Data source indicators:** Small badge icons (Plaid logo for connected, manual entry icon for others)
- Tap segments to filter asset list below

**Quick Stats Cards (Horizontal Scroll):**

- Best Performer (asset with highest % gain)
- Worst Performer
- Top Holdings (by value)
- **Connected Accounts Count:** "5 accounts synced" with checkmark
- Each card: Icon, asset name/account, change %, tap to navigate to detail

**Asset List Preview:**

- Show top 5-7 holdings by value (aggregated from all sources)
- Each row:
  - Institution logo (for Plaid) or custom icon (manual)
  - Asset name
  - Account source (e.g., "Fidelity" or "Manual Entry")
  - Current value, % change, trend indicator
- "View All Accounts" button → navigates to Accounts tab

**Sync Status Banner (if applicable):**

- "Syncing with Fidelity..." (animated dots)
- "Last sync failed - Tap to reconnect" (error state)

**Pull-to-Refresh:** Triggers Plaid data refresh + manual asset price updates

---

## 2. Accounts Screen (Replaces Assets)

**Purpose:** Manage Plaid-connected accounts + manual asset entries

### Main View Structure

**Section 1: Connected Accounts (Plaid)**

**Header:**

- "Connected Accounts" title
- "Add Account" button (primary CTA)

**Account Cards (List):**
Each connected institution shows as a card:

- **Header:** Institution logo + name (e.g., "Charles Schwab")
  - Sync status indicator (green checkmark or red warning)
  - Last synced timestamp
  - Chevron → Account Detail View
- **Summary:** Total value across all accounts at this institution
- **Account List (nested):**
  - Individual accounts (e.g., "Roth IRA", "Brokerage")
  - Each shows: Account name, mask (last 4 digits), balance/value
- **Swipe Actions:** Disconnect Account (shows confirmation alert)

**Empty State (no connections):**

- Illustration (bank building + link icon)
- "Connect Your Accounts"
- Subtitle: "Automatically track stocks, crypto, and funds from 12,000+ institutions"
- Large "Connect Account" button → Launches Plaid Link

**Section 2: Manual Assets**

**Header:**

- "Manual Entries" title
- "Add Asset" button (+ icon)

**Asset Cards (List):**

- Same design as previous brief (icon, name, value, % change, trend)
- Badge: "Manual" to differentiate from Plaid data
- Swipe actions: Edit, Delete

**Empty State:**

- "No manual assets" + "Add Asset" CTA

### Plaid Link Flow UI

**Trigger Points:**

1. Tap "Add Account" in Connected Accounts section
2. Tap "Connect Account" from empty state
3. Tap "Reconnect" on failed sync banner

**Integration Steps (UI Perspective):**

```swift
// Simplified flow - actual Plaid SDK handles UI
Button("Connect Account") {
    presentPlaidLink()
}

func presentPlaidLink() {
    // Plaid presents native modal with:
    // 1. Institution search
    // 2. Credential entry (OAuth redirect)
    // 3. Account selection
    // 4. Success confirmation

    // On success callback:
    // - Receive public_token
    // - Send to backend to exchange for access_token
    // - Backend fetches account/holdings data
    // - Refresh UI with new accounts
}
```

**Plaid Link Native Modal (SDK handles this):**

- Search bar for institution selection
- Popular institutions grid (e.g., Fidelity, Robinhood, Coinbase)
- OAuth browser view for login
- Multi-factor authentication screens
- Account selection checklist
- Success screen with checkmark animation

**Post-Connection:**

- Dismiss Plaid modal
- Show loading overlay: "Syncing your accounts..."
- Fetch data from backend (Plaid API via your server)
- Animate new account card sliding into list
- Success toast: "Charles Schwab connected!"

### Account Detail View (Plaid Connected)

**Header:**

- Institution logo + name
- Account type badge (e.g., "Brokerage", "401k")
- Account mask (e.g., "••••5678")
- Reconnect button (if auth expired)

**Account Summary:**

- Current balance/value (large)
- Cash available
- Day change
- Total gain/loss since inception (if available from Plaid)

**Holdings List:**

- Grouped by asset type (Stocks, Bonds, Funds, Crypto)
- Each holding:
  - Ticker/symbol + name
  - Shares/quantity
  - Cost basis (if available)
  - Current value
  - Gain/loss (% and $)
  - Mini trend sparkline
- Tap holding → Individual Asset Detail View (same as manual entry)

**Transactions (if applicable):**

- Recent buy/sell activity from Plaid
- Date, type, ticker, shares, price
- Filter by date range

**Actions:**

- Update Account (manual refresh from Plaid)
- Disconnect Account (confirmation alert)

### Add/Edit Manual Asset Sheet (Updated)

**Form Fields:**

- Asset type picker (Stock, Crypto, Precious Metal, Real Estate, Fixed Income, Other)
- Name text field
- Ticker/symbol (optional, with autocomplete search for stocks)
- Purchase price & quantity
- Purchase date (date picker)
- **Account Association (new):**
  - Dropdown: "Unassigned" or select a connected account
  - Allows grouping manual entries with Plaid accounts
- Custom tags
- Notes
- Save/Cancel buttons

**Enhanced Features:**

- If ticker entered, auto-fetch current price from Yahoo Finance/Alpha Vantage
- Photo attachment (e.g., for real estate, gold bars)

---

## 3. Analytics Screen (Premium Feature - Updated)

### New Data Sources Section

**Connected Accounts Overview:**

- List all Plaid institutions with sync health
- Data quality indicators (e.g., "Complete" vs. "Partial" if some data missing)
- Coverage badge: "95% of portfolio auto-tracked"

**Risk Dashboard:**

- Same as before, but now with enriched Plaid data:
  - Sector/geography from actual holdings (not user-entered)
  - Real-time correlation calculations
  - More accurate volatility metrics

**Plaid-Specific Insights (Premium):**

- "Cash Drag Analysis": Highlight idle cash in brokerage accounts
- "Fee Detector": Estimate annual fees from fund holdings (expense ratios)
- "Tax Loss Harvesting": Identify holdings with losses (from Plaid cost basis)

---

## 4. Settings Screen (Updated)

### New Section: Account Connections

**Plaid Management:**

- List of connected institutions
- Each row: Logo, name, account count, last synced
- Tap → Account settings:
  - Reconnect (if expired)
  - Update credentials
  - Disconnect
- "Connection History" log (timestamps, errors)

**Data Sync Preferences:**

- Auto-sync toggle (default: on)
- Sync frequency: Every 6/12/24 hours
- Wi-Fi only toggle
- Background refresh permission status

**Privacy & Security:**

- "How We Use Plaid" info sheet
- Data encryption badge
- "Plaid doesn't store credentials" reassurance text
- Link to Plaid's privacy policy

**Troubleshooting:**

- "Fix Connection Issues" button → Help article
- "Re-authenticate All" bulk action

### Existing Sections (No Change)

- Profile, Subscription, Preferences, Data Management, Support, Legal

---

## 5. Onboarding Flow (New - Critical for Plaid)

**Purpose:** Guide users to connect accounts immediately for high engagement

### Screen 1: Welcome

- App logo + tagline
- "All Your Investments, One Dashboard"
- Primary button: "Get Started"
- Secondary: "Sign In"

### Screen 2: Value Proposition

- 3 feature cards with icons:
  1. "Auto-Sync 12,000+ Institutions" (Plaid logo badge)
  2. "Track Any Asset, Anywhere"
  3. "Smart Risk Insights" (Premium badge)
- Primary button: "Connect Accounts"

### Screen 3: Plaid Education (Important!)

- Illustration of secure connection
- Headline: "Safe & Secure with Plaid"
- Bullets:
  - "Bank-level encryption"
  - "We never see your passwords"
  - "Read-only access"
  - Plaid logo + "Trusted by 8,000+ apps"
- Primary button: "Connect My First Account"
- Secondary: "Skip for Now" → Go to dashboard with empty state

### Screen 4: Launch Plaid Link

- Immediate Plaid modal presentation
- On success → Dashboard with new data
- On skip → Dashboard with "Connect Account" CTA cards

---

## Plaid Integration Architecture (Frontend Perspective)

### Plaid Link SDK Setup

**Installation:**

```swift
// Package.swift or SPM
dependencies: [
    .package(url: "https://github.com/plaid/plaid-link-ios", from: "5.0.0")
]
```

**Initialization:**

```swift
import LinkKit

class PlaidManager: ObservableObject {
    @Published var linkToken: String? // Fetch from your backend

    func createLinkConfiguration() -> LinkTokenConfiguration {
        var config = LinkTokenConfiguration(token: linkToken!) { success in
            // Handle success: public_token, metadata
            self.exchangePublicToken(success.publicToken)
        }
        config.onExit = { exit in
            // Handle user cancellation or errors
        }
        return config
    }

    func presentPlaid(in viewController: UIViewController) {
        let config = createLinkConfiguration()
        let result = Plaid.create(config)

        switch result {
        case .success(let handler):
            handler.open(presentUsing: .viewController(viewController))
        case .failure(let error):
            // Show error to user
        }
    }

    private func exchangePublicToken(_ token: String) {
        // Call your backend API:
        // POST /exchange_public_token
        // Backend exchanges with Plaid for access_token
        // Backend then calls Plaid API to fetch accounts/holdings
        // Return account data to app
    }
}
```

**SwiftUI Integration:**

```swift
struct AccountsView: View {
    @StateObject private var plaidManager = PlaidManager()

    var body: some View {
        Button("Connect Account") {
            // Present Plaid Link
            plaidManager.presentPlaid(in: UIApplication.shared.currentUIViewController())
        }
    }
}
```

### Backend Communication Flow (UI Implications)

**Step 1: Get Link Token**

- App launches → Call backend `GET /create_link_token`
- Backend calls Plaid API to generate link_token
- App stores token → Enables "Connect Account" button

**Step 2: User Connects via Plaid Link**

- User completes Plaid flow
- App receives `public_token` + account metadata
- Send to backend `POST /exchange_public_token`

**Step 3: Backend Processes Data**

- Backend exchanges public_token for access_token (stored securely)
- Backend calls Plaid `/accounts/get` and `/investments/holdings/get`
- Returns simplified account data to app as JSON

**Step 4: App Updates UI**

- Parse account data into SwiftUI models
- Save to local database (SwiftData)
- Refresh dashboard and accounts list
- Show success animation

**Step 5: Periodic Syncs**

- App calls backend `POST /sync_accounts` (with access_token reference)
- Backend fetches latest data from Plaid
- Returns updated holdings
- App diffs changes and updates UI

### Error States & Handling

**Connection Errors:**

- Plaid SDK errors (invalid credentials, MFA timeout, etc.)
- Show user-friendly message: "Couldn't connect to [Institution]. Please try again."
- Retry button → Re-launch Plaid Link

**Sync Failures:**

- Institution requires re-authentication (Plaid Item error)
- Show banner on account card: "Action Required: Reconnect Charles Schwab"
- Tap banner → Launch Plaid Update Mode:
  ```swift
  config.updateMode = .updateMode(publicToken: existingPublicToken)
  ```

**Partial Data:**

- Some accounts synced, others failed
- Show mixed state: Green checkmarks on success, warning icons on failures
- Per-account error messages

**Rate Limits:**

- If Plaid API limit reached, show cached data
- Banner: "Using recent data - Live updates paused"

---

## Data Models (Updated)

```swift
// Plaid-Connected Account
@Model
class ConnectedAccount: Identifiable {
    let id: UUID
    var institutionName: String
    var institutionLogo: URL?
    var plaidItemId: String // Reference to Plaid Item
    var accessToken: String // Store securely (Keychain)
    var accounts: [SubAccount]
    var lastSynced: Date
    var syncStatus: SyncStatus
}

enum SyncStatus {
    case synced, syncing, failed(String), needsReauth
}

@Model
class SubAccount: Identifiable {
    let id: UUID
    var accountId: String // Plaid account_id
    var name: String // "Roth IRA"
    var mask: String // "5678"
    var type: AccountType // .investment, .depository, .credit
    var balance: Double
    var holdings: [Holding]
}

@Model
class Holding: Identifiable {
    let id: UUID
    var ticker: String?
    var name: String
    var type: AssetType
    var quantity: Double
    var costBasis: Double? // From Plaid if available
    var currentPrice: Double
    var institutionPrice: Double? // Plaid's price vs. market price
    var isManual: Bool = false
}

// Manual Asset (same as before)
@Model
class ManualAsset: Identifiable {
    let id: UUID
    var name: String
    var type: AssetType
    var quantity: Double
    var purchasePrice: Double
    var currentPrice: Double
    var associatedAccountId: UUID? // Link to ConnectedAccount
}
```

---

## Security Considerations (UI Indicators)

1. **Never Store Credentials:**
   - Plaid handles all login flows
   - Display reassurance text: "We never see your password"

2. **Token Storage:**
   - Access tokens stored in iOS Keychain (not UserDefaults)
   - UI: Show "🔒 Encrypted" badge in Settings

3. **Permissions:**
   - Plaid Link shows explicit permission screen
   - App shows "Read-Only Access" badge on account cards

4. **Plaid Branding:**
   - Required: Display "Powered by Plaid" logo in onboarding and account connections
   - Use official Plaid logo assets

---

## UI States & Animations (Plaid-Specific)

### Connection Flow

1. **Loading State:**
   - Shimmer effect on account cards placeholder
   - "Connecting to [Institution]..." with spinner

2. **Success Animation:**
   - Checkmark ✓ with scale + fade animation
   - New account card slides in from right
   - Confetti burst (optional, subtle)

3. **Sync in Progress:**
   - Rotating sync icon on account card
   - Progress bar if batch syncing multiple accounts

4. **Stale Data Indicator:**
   - Gray dot next to timestamp: "Last synced 3 days ago"
   - Tap to manually refresh

### Error Visual Language

- **Needs Reauth:** Orange warning triangle
- **Sync Failed:** Red exclamation mark
- **Partial Data:** Yellow info icon with "Some data unavailable"

---

## Design System Updates

### New Color Tokens

- **Plaid Blue:** `#1A73E8` (for Plaid-related UI elements)
- **Sync Green:** `#34C759` (successful sync indicator)
- **Warning Orange:** `#FF9500` (reauth needed)

### Institution Logos

- Fetch from Plaid API metadata
- Fallback: Generic bank icon (SF Symbol: `building.columns.fill`)
- Cache logos locally (URLCache)

### New Icons (SF Symbols)

- `link.circle.fill` - Connect account
- `arrow.triangle.2.circlepath` - Sync/refresh
- `exclamationmark.triangle.fill` - Warning/error
- `checkmark.seal.fill` - Verified/secure

---

## Accessibility (Updated)

- **Plaid Link:** SDK handles accessibility internally
- **Account Cards:**
  - VoiceOver labels: "[Institution Name] account, [Balance], last synced [Timestamp], [Status]"
- **Sync Buttons:** Announce state changes ("Syncing...", "Sync complete")
- **Error Banners:** VoiceOver priority for reauth prompts

---

## Deliverables Checklist (Updated)

### Phase 1: Core UI + Plaid Integration

- [ ] TabView navigation with Accounts tab
- [ ] Onboarding flow with Plaid education
- [ ] Plaid Link SDK integration (iOS wrapper)
- [ ] Connected Accounts list view
- [ ] Account detail view with holdings
- [ ] Manual asset entry (fallback)
- [ ] Dashboard with aggregated data
- [ ] Sync status indicators
- [ ] Error handling UI (reauth, failures)
- [ ] Settings > Account Connections management
- [ ] Mock backend API responses for development
- [ ] Keychain storage for tokens
- [ ] Pull-to-refresh on all data views

### Phase 2: Premium Features

- [ ] Analytics with Plaid-enriched data
- [ ] Goal tracking
- [ ] RevenueCat paywall
- [ ] Tax loss harvesting insights

### Phase 3: Backend Integration

- [ ] Real Plaid API backend
- [ ] Webhook handling (Item updates)
- [ ] Background data sync
- [ ] Push notifications for sync events

---

## Backend Requirements (For Reference)

Your backend must implement:

1. **Plaid Endpoints:**
   - `POST /create_link_token` → Returns link_token for Plaid Link
   - `POST /exchange_public_token` → Exchanges public_token for access_token
   - `POST /sync_accounts` → Fetches latest data from Plaid
   - `POST /disconnect_account` → Removes Plaid Item

2. **Plaid API Calls:**
   - `/accounts/get` - Basic account info
   - `/investments/holdings/get` - Portfolio holdings
   - `/investments/transactions/get` - Trade history
   - `/item/webhook/update` - Register webhooks

3. **Data Transformation:**
   - Map Plaid security objects to app's Asset models
   - Handle currency conversions
   - Aggregate holdings across accounts

4. **Webhook Listeners:**
   - Handle Plaid Item errors (reauth needed)
   - Process automatic updates
   - Send push notifications to app

---

## Testing Strategy

### Plaid Sandbox Mode

- Use Plaid's Sandbox environment for development
- Test institutions: "Platypus Bank", "Tattersall FCU"
- Test credentials provided by Plaid docs
- Simulate errors: Invalid MFA, locked accounts

### UI Testing Scenarios

1. First-time connection (empty state → success)
2. Add second institution
3. Reconnect expired account
4. Handle sync failure
5. Disconnect account
6. Mix Plaid + manual assets
7. Offline mode (show cached data)

### Edge Cases

- User denies account permissions in Plaid
- Zero holdings in connected account
- Institution temporarily down
- Duplicate accounts from same institution
- Extremely large portfolios (1000+ holdings)

---

## Next Steps for Coding Agent

1. **Setup:**
   - Add Plaid Link SDK via SPM
   - Create mock backend API (JSON files or local server)
   - Set up Keychain wrapper for secure storage

2. **Core Implementation:**
   - Build onboarding flow
   - Integrate Plaid Link presentation
   - Create ConnectedAccount and Holding models
   - Implement Accounts list view
   - Build account detail view
   - Add manual asset fallback

3. **Data Flow:**
   - Mock public_token exchange
   - Parse Plaid API JSON responses
   - Implement local caching (SwiftData)
   - Build sync engine

4. **UI Polish:**
   - Add all animations and transitions
   - Implement error states
   - Create loading skeletons
   - Test dark mode

5. **Testing:**
   - Unit tests for data models
   - UI tests for connection flow
   - Test Plaid Sandbox integration

---

**Critical Notes:**

- **Plaid Pricing:** Free for development (100 Items), paid in production. Plan accordingly.
- **Institution Coverage:** Test that XTB, Renta 4 (Spanish brokers) are supported via Plaid EU. If not, manual entry required.
- **Data Latency:** Plaid updates aren't real-time (hourly/daily for most institutions). Show last sync time prominently.
- **User Education:** Most users haven't used Plaid—spend time on trust-building in onboarding.

This updated brief provides complete Plaid integration architecture while maintaining all original features. The coding agent now has clear instructions for building a Plaid-first experience with manual fallback.
