import 'dart:convert';

import 'package:test_app/core/error/exceptions.dart';
import 'package:test_app/features/test_app/data/models/number_trivia_model.dart';
import 'package:test_app/features/test_app/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  
  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) => _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTrivia> getRandomNumberTrivia() => _getTriviaFromUrl("http://numbersapi.com/random");

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        "Content_Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}