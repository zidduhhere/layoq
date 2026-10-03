# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project purpose

Layoq is a Flutter mobile app: an outdoor advertising marketplace that connects advertisers with available billboard space, modeled on the ease of discovery of Airbnb rather than a corporate media-planning dashboard.

**MVP scope (current target):**
- Launch city: Kochi only.
- Inventory type: Static billboards only — no DOOH/digital screens, no route-based search, no live maps, no in-app payments, no messaging, no media-owner self-service. These are explicitly later-phase.
- Booking model is **request-based, not instant booking**: advertisers submit a request for selected dates; Layoq's admin team accepts or rejects it; accepted bookings block those billboard dates. Users track pending/upcoming/active/completed campaigns.
- Admin operations (listing creation/management, availability, approve/reject requests) happen in a separate Admin Panel, not in this app. There is no media-owner app in V1.

**Primary users:** business owners, marketing teams, advertising agencies, independent marketers. A user may represent their own business, an agency, or multiple clients/organisations.

**Core advertiser journey:**
1. Search billboard spaces in an area of Kochi.
2. Optionally set campaign start/end dates as an availability filter.
3. Browse matching listings.
4. View a listing's photos, location, size, illumination, price, and availability.
5. Save to wishlist or submit a booking request.
6. Track requests/bookings under Campaigns.

**Navigation:** 4 bottom-nav sections — Explore, Wishlist, Campaigns, Profile. No logo or profile icon in the top app bar (Profile already lives in bottom nav).

**Home screen priorities:**
- Area search + optional campaign dates as the main filter.
- One primary CTA: "Search ad spaces."
- Browsing is allowed without sign-in.
- OTP sign-in is required only when saving a listing, submitting a booking request, or viewing protected account info — not for browsing.
- No "Popular locations" section (MVP is Kochi-only, so it's redundant).

**Design direction:** mobile-first, approachable/trustworthy/low-pressure, generous whitespace, familiar controls, comfortable touch targets, restrained hierarchy, plain language (e.g. "Static billboard" not unexplained ad-industry jargon). Ask only for info that creates a visible user benefit — e.g. dates solve availability uncertainty and are useful; campaign objective/target-audience fields are not needed in the MVP, campaign name is optional at booking time.

## Current stage

The repository is currently a **stock `flutter create` scaffold** — no app-specific code has been written yet:
- `lib/main.dart` is still the default Flutter counter-app demo.
- `test/widget_test.dart` is still the default counter-app widget test.
- No routing, state management, models, networking, or design system have been set up.
- Not yet a git repository.

When implementing features, there is no existing architecture to conform to — establish one deliberately (navigation shell with the 4 bottom-nav tabs, a data layer for listings/bookings, auth gating for OTP-required actions) rather than discovering it from existing files.

## Commands

Standard Flutter tooling applies (Flutter SDK `^3.13.2`, per `pubspec.yaml`):

```bash
flutter pub get             # install dependencies
flutter run                 # run on a connected device/simulator
flutter analyze             # static analysis (uses flutter_lints via analysis_options.yaml)
flutter test                # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter build apk           # Android build
flutter build ios           # iOS build
```

`analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**` from analysis and includes `package:flutter_lints/flutter.yaml` with no custom rule overrides yet.
