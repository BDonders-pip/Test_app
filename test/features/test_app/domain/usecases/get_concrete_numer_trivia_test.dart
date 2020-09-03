import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/test_app/domain/entities/number_trivia.dart';
import 'package:test_app/features/test_app/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/test_app/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1; // test number
  final tNumberTrivia = NumberTrivia(number: tNumber, text: "test");

  test(
    "should get trivia for the number from the repository",
      () async {
        //arange
        when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        final result = await usecase(Params(number: tNumber));

        // assert
        expect(result, Right(tNumberTrivia));
        verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockNumberTriviaRepository);
      },
  );
}
