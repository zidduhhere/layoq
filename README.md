# Layoq 🏙️

Layoq is a modern, minimalist Flutter application designed for discovering, reserving, and managing billboard and ad space in Kochi. Built with a focus on premium aesthetics and effortless user experience, Layoq bridges the gap between businesses and physical advertising spaces.

## Features ✨

* **Interactive Map Discovery:** Explore available ad spaces across Kochi using a custom-painted, interactive map interface with stylized components.
* **Rich Listing Details:** View in-depth information about billboards including daily traffic, material types, illumination status, and minimum booking durations.
* **Campaign Management:** Keep track of your past, upcoming, and active ad campaigns.
* **Wishlist:** Save your favorite billboard locations for quick access and comparison.
* **Premium Aesthetics:** Clean, white-background cards, hairline borders, dynamic drop-shadows, and curated typography.
* **Haptic Feedback:** Tactile interactions across the entire app for a premium, iOS-like feel.

## Tech Stack 🛠️

* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** [Dart](https://dart.dev/)
* **Architecture:** Component-based UI with centralized Theme and Content management (`AppColors`, `AppTextStyles`, `AppCopy`).

## Project Structure 📁

- `lib/core/` - Global theme definitions, colors, typography, and centralized UX copy.
- `lib/models/` - Data models like `BillboardListing`.
- `lib/data/` - Mock data for listings.
- `lib/screens/` - Main application screens (`Explore`, `SearchResults`, `ListingDetail`, `Wishlist`, etc).
- `lib/widgets/` - Reusable UI components categorized by feature (e.g., `explore`, `map`).

## Getting Started 🚀

1. Ensure you have Flutter installed.
2. Clone the repository: `git clone https://github.com/zidduhhere/layoq.git`
3. Run `flutter pub get` to fetch dependencies.
4. Run the app on your preferred emulator or physical device using `flutter run`.

## Design Philosophy 🎨

Layoq adheres to a strict minimalist design philosophy:
- **No unnecessary colors:** Core UI elements rely on `AppColors.hairline` and white backgrounds. 
- **Typography:** Clear hierarchy using predefined `AppTextStyles`.
- **Copywriting:** Plain, concise, and professional text maintained exclusively in `app_copy.dart`.
