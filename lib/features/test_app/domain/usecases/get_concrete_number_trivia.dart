import 'package:equatable/equatable.dart';
import 'package:test_app/core/usecases/usecase.dart';
import 'package:test_app/features/test_app/domain/repositories/number_trivia_repository.dart';
import 'package:test_app/features/test_app/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failures.dart';
import "package:meta/meta.dart";

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  // api.com/42
  // api.com/random

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number}) : super([number]);
}

// all usecases must have a call method