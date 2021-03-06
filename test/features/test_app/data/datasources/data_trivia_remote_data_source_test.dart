import 'dart:convert';

import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import 'package:test_app/core/error/exceptions.dart';
import 'package:test_app/features/test_app/data/datasources/number_trivia_remote_data_source.dart';
import 'package:test_app/features/test_app/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  });

  void setUpMockHttpClientSucces200() {
    when(mockHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response("Georgerous error", 404));
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
      "sould perfom a GET request on a URL with number being the endpoint and with application/json header",
        () async {
          // arrange
          setUpMockHttpClientSucces200();
          // act
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockHttpClient.get("http://numbersapi.com/$tNumber",
          headers: {"Content_Type": "application/json"}));
        },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
        () async {
          // arrange
          setUpMockHttpClientSucces200();
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getConcreteNumberTrivia;
          // assert
          expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
        }
    );
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
      "sould perfom a GET request on a URL with number being the endpoint and with application/json header",
          () async {
        // arrange
        setUpMockHttpClientSucces200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get("http://numbersapi.com/random",
            headers: {"Content_Type": "application/json"}));
      },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
          () async {
        // arrange
        setUpMockHttpClientSucces200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
        "should throw a ServerException when the response code is 404 or other",
            () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getRandomNumberTrivia;
          // assert
          expect(() => call(), throwsA(TypeMatcher<ServerException>()));
        }
    );
  });
}
