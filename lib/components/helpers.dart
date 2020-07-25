import 'package:cpf_cnpj_validator/cnpj_validator.dart';

String requiredValidator(value) {
  if (value.isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

String cnpjValidator(value) {
  if(!CNPJValidator.isValid(value)) {
    return 'Digite um CNPJ válido';
  }
  return null;
}

String multiplesValidators(String value, List<Function(String)> validators) {
  for (var validator in validators) {
    var validation = validator(value);
    if (validation != null) {
      return validation;
    }
  }
  return null;
}
