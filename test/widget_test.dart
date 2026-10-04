import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layoq/models/booking_request.dart';
import 'package:layoq/providers/providers.dart';

void main() {
  ProviderContainer make() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('auth: invalid email is rejected, valid email reaches code step', () {
    final c = make();
    final auth = c.read(authProvider.notifier);
    expect(auth.sendCode('nope'), isFalse);
    expect(c.read(authProvider).error, isNotNull);
    expect(auth.sendCode('a@b.co'), isTrue);
    expect(c.read(authProvider).step, AuthStep.otp);
    expect(auth.verify('123'), isFalse);
    expect(auth.verify('123456'), isTrue);
    expect(c.read(isSignedInProvider), isTrue);
    auth.signOut();
    expect(c.read(isSignedInProvider), isFalse);
  });

  test('wishlist toggles listings', () {
    final c = make();
    final id = c.read(listingsProvider).first.id;
    c.read(wishlistIdsProvider.notifier).toggle(id);
    expect(c.read(wishlistProvider).single.id, id);
    expect(c.read(isSavedProvider(id)), isTrue);
    c.read(wishlistIdsProvider.notifier).toggle(id);
    expect(c.read(wishlistProvider), isEmpty);
  });

  test('search filters by area; campaigns reject duplicate pending', () {
    final c = make();
    final first = c.read(listingsProvider).first;
    c.read(searchFilterProvider.notifier).setArea(first.area);
    expect(c.read(searchResultsProvider), contains(first));
    c.read(searchFilterProvider.notifier).setArea('zzzz');
    expect(c.read(searchResultsProvider), isEmpty);

    final campaigns = c.read(campaignsProvider.notifier);
    final range = DateTimeRange(
      start: DateTime(2030, 1, 1),
      end: DateTime(2030, 1, 8),
    );
    expect(campaigns.request(first, range), isTrue);
    expect(campaigns.request(first, range), isFalse);
    expect(c.read(visibleCampaignsProvider), hasLength(1));
    c.read(campaignTabProvider.notifier).select(CampaignStatus.active);
    expect(c.read(visibleCampaignsProvider), isEmpty);
  });

  test('date draft orders a reversed range', () {
    final c = make();
    final d = c.read(dateDraftProvider.notifier);
    d.tapDay(DateTime(2030, 1, 10));
    d.tapDay(DateTime(2030, 1, 5));
    expect(c.read(dateDraftProvider).range!.start, DateTime(2030, 1, 5));
  });
}
