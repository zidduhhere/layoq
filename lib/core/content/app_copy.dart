/// All user-facing copy in one place: headings, body text, labels,
/// hints, and button text. Keep it short and plain — no ad-industry
/// jargon, no filler sentences. Edit copy here, not in the screens.
class AppCopy {
  AppCopy._();

  // Nav
  static const String navExplore = 'Explore';
  static const String navWishlist = 'Wishlist';
  static const String navCampaigns = 'Campaigns';
  static const String navProfile = 'Profile';

  // Explore
  static const String exploreGreeting = 'Good morning';
  static const String exploreSubtitle = 'Explore billboard space across Kochi.';
  static const String availableSpacesTitle = 'Available in Kochi';
  static const String availableSpacesSubtitle = 'Live listings, updated daily.';
  static const String recentlyViewedTitle = 'Recently viewed';
  static const String searchCardTitle = 'Area in Kochi';
  static const String searchHint = 'Search places';
  static String searchResultsCount(int count) => '$count spaces available';
  static const String campaignDatesLabel = 'Campaign dates';
  static const String addDatesPlaceholder = 'Add dates';
  static const String searchButton = 'Search';
  static const String illuminatedBadge = 'Illuminated';
  static const String perMonthSuffix = ' / month';

  // Wishlist
  static const String wishlistTitle = 'Wishlist';
  static const String wishlistSubtitle = 'Your saved spaces.';
  static const String wishlistEmptyTitle = 'Nothing saved yet';
  static const String wishlistEmptyBody = 'Tap the heart to save a space.';

  // Campaigns
  static const String campaignsTitle = 'Campaigns';
  static const String campaignsSubtitle = 'Your booking requests.';
  static const String campaignStatusPending = 'Pending';
  static const String campaignStatusUpcoming = 'Upcoming';
  static const String campaignStatusActive = 'Active';
  static const String campaignStatusCompleted = 'Completed';
  static const String campaignsEmptyBody = 'Request a space to see it here.';

  static String campaignsEmptyTitle(String status) => 'No $status campaigns';

  // Notifications
  static const String notificationsTitle = 'Notifications';
  static const String notificationsEmptyTitle = 'No notifications yet';
  static const String notificationsEmptyBody =
      'When you get updates about your bookings, they\'ll appear here.';

  // Auth
  static const String authHeadline = 'Find the right wall for your brand.';
  static const String authEmailLabel = 'Email';
  static const String authEmailHint = 'you@company.com';
  static const String authEmailInvalid = 'Enter a valid email address.';
  static const String authSendCode = 'Sign Up';
  static const String authOr = 'or';
  static const String authGoogle = 'Continue with Google';
  static const String authOtpTitle = 'Enter the code';
  static String authOtpBody(String email) =>
      'We sent a 6-digit code to $email.';
  static const String authOtpIncomplete = 'Enter all 6 digits.';
  static const String authVerify = 'Verify and continue';
  static const String authChangeEmail = 'Use a different email';
  static const String authResend = 'Resend code';
  static String authResendIn(int s) => 'Resend code in ${s}s';
  static const String authTerms =
      'By continuing, you agree to the Terms & policies.';

  // Profile
  static const String profileTitle = 'Profile';
  static const String signInPrompt = 'Sign in to manage your bookings.';
  static const String signInButton = 'Sign in';
  static const String menuMyBusiness = 'My business';
  static const String menuHelp = 'Help & support';
  static const String menuTerms = 'Terms & policies';
  static const String menuAbout = 'About Layoq';

  // Listing detail
  static const String aboutSpaceTitle = 'About this space';
  static const String illuminatedLabel = 'Illuminated';
  static const String nonIlluminatedLabel = 'Non-illuminated';
  static const String requestToBookButton = 'Request to book';

  static String aboutSpaceBody({
    required String landmark,
    required String sizeLabel,
    required bool illuminated,
  }) {
    return '$sizeLabel billboard near $landmark'
        '${illuminated ? ', illuminated at night' : ''}.';
  }
}
