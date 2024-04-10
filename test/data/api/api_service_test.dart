import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/model/local_restaurant.dart';
import 'package:restaurant_app/model/local_restaurant_detail.dart';
import 'package:restaurant_app/model/local_restaurant_search.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/model/review.dart';

import '../../response_body/customer_post_review_body.dart';
import '../../response_body/restaurant_detail_body.dart';
import '../../response_body/restaurant_list_body.dart';
import '../../response_body/restaurant_search_body.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final client = MockClient();
  group("restaurant list", () {
    test("fetch restaurant list - success", () async {
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
              restaurantListBody,
              200));
      var restaurantList = await ApiService(client: client).restaurantList();
      expect(restaurantList, isA<LocalRestaurant>());
      expect(restaurantList.error, false);
      expect(restaurantList.message, "success");
      expect(restaurantList.count, 20);
      expect(restaurantList.restaurants, isA<List<Restaurant>>());
    });
  });
  group("restaurant detail", () {
    test("fetch restaurant detail - success", () async {
      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/ygewwl55ktckfw1e867')))
          .thenAnswer((_) async => http.Response(restaurantDetailBody, 200));
      var restaurantDetail = await ApiService(client: client)
          .restaurantDetail('ygewwl55ktckfw1e867');
      expect(restaurantDetail, isA<LocalRestaurantDetail>());
      expect(restaurantDetail.error, false);
      expect(restaurantDetail.message, "success");
      expect(restaurantDetail.restaurant, isA<RestaurantDetail>());
    });
  });
  group("restaurant search", () {
    test("fetch restaurant search - success", () async {
      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=kafe')))
          .thenAnswer((_) async => http.Response(restaurantSearchBody, 200));
      var restaurantSearch =
          await ApiService(client: client).restaurantSearch('kafe');
      expect(restaurantSearch, isA<LocalRestaurantSearch>());
      expect(restaurantSearch.error, false);
      expect(restaurantSearch.founded, 4);
      expect(restaurantSearch.restaurants, isA<List<Restaurant>>());
    });
  });
  group("post restaurant review", () {
    test("post restaurant review - success", () async {
      when(client.post(
        Uri.parse('https://restaurant-api.dicoding.dev/review'),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(PostReview(
                id: 'ygewwl55ktckfw1e867', name: 'Sayid', review: 'Halo Dunia')
            .toJson()),
      )).thenAnswer((_) async => http.Response(customerPostReviewBody, 200));
      var postReview = await ApiService(client: client).postReview(PostReview(
          id: 'ygewwl55ktckfw1e867', name: 'Sayid', review: 'Halo Dunia'));
      Review encodedPostReview = Review.fromJson(json.decode(postReview.body));
      expect(encodedPostReview, isA<Review>());
      expect(encodedPostReview.error, false);
      expect(encodedPostReview.message, "success");
      expect(encodedPostReview.customerReviews, isA<List<CustomerReview>>());
    });
  });
}
