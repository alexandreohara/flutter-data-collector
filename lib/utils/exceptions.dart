class AuthenticationException implements Exception {
  final String error;
  AuthenticationException(this.error);

  @override
  String toString() => 'Erro de autenticação: $error';
}

class ErrorAddingRowException implements Exception {
  final String message;
  ErrorAddingRowException(this.message);

  @override
  String toString() => 'Erro ao adicionar uma linha: $message';
}

class CreateOrFetchSheetException implements Exception {
  final String error;
  CreateOrFetchSheetException(this.error);

  @override
  String toString() => 'Erro ao criar ou buscar a planilha: $error';
}

class FetchSheetException implements Exception {
  final String error;
  FetchSheetException(this.error);

  @override
  String toString() => 'Erro ao buscar a planilha: $error';
}

class NumberAlreadyExistsException implements Exception {
  final String number;
  NumberAlreadyExistsException(this.number);

  @override
  String toString() => 'A placa $number já existe na planilha';
}
