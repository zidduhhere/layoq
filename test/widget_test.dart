import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layoq/models/booking_request.dart';
import 'package:layoq/providers/providers.dart';

class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({String? session}) : _email = session;

  final _controller =
      StreamController<({bool signedIn, String? email})>.broadcast();
  final sentTo = <String>[];
  bool signedOut = false;
  String? _email;

  void emit({required bool signedIn, String? email}) {
    _email = signedIn ? email : null;
    _controller.add((signedIn: signedIn, email: email));
  }

  @override
  bool get hasSession => _email != null;
  @override
  String? get email => _email;
  @override
  Stream<({bool signedIn, String? email})> get changes => _controller.stream;
  @override
  Future<void> sendMagicLink(String email) async => sentTo.add(email);
  @override
  Future<void> signOut() async {
    signedOut = true;
    emit(signedIn: false);
  }
}

void main() {
  ProviderContainer make([FakeAuthGateway? gateway]) {
    final c = ProviderContainer(
      overrides: [
        authGatewayProvider.overrideWithValue(gateway ?? FakeAuthGateway()),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test(
    'auth: invalid email is rejected, link is sent for a valid one',
    () async {
      final gateway = FakeAuthGateway();
      final c = make(gateway);
      final auth = c.read(authProvider.notifier);
      expect(await auth.sendLink('nope'), isFalse);
      expect(c.read(authProvider).error, isNotNull);
      expect(gateway.sentTo, isEmpty);
      expect(await auth.sendLink(' a@b.co '), isTrue);
      expect(gateway.sentTo, ['a@b.co']);
      expect(c.read(authProvider).step, AuthStep.linkSent);
      expect(c.read(isSignedInProvider), isFalse);
    },
  );

  test(
    'auth: session from the tapped link signs in; sign-out clears it',
    () async {
      final gateway = FakeAuthGateway();
      final c = make(gateway);
      c.listen(authProvider, (_, _) {});
      await c.read(authProvider.notifier).sendLink('a@b.co');
      gateway.emit(signedIn: true, email: 'a@b.co');
      await Future<void>.delayed(Duration.zero);
      expect(c.read(isSignedInProvider), isTrue);
      expect(c.read(authProvider).email, 'a@b.co');
      await c.read(authProvider.notifier).signOut();
      expect(gateway.signedOut, isTrue);
      expect(c.read(isSignedInProvider), isFalse);
    },
  );

  test('auth: restores an existing session on launch', () {
    final c = make(FakeAuthGateway(session: 'a@b.co'));
    expect(c.read(isSignedInProvider), isTrue);
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
