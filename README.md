# Nubank Shorten Links

Um projeto Flutter para encurtar e gerenciar links, desenvolvido seguindo boas práticas de **arquitetura em camadas**, testes automatizados e integração contínua.

---

## 🚀 Arquitetura

Este projeto segue uma arquitetura em **camadas (Clean Architecture simplificada)** para promover desacoplamento, testabilidade e escalabilidade:

- **Data Layer**
  - Contém implementações concretas de repositórios e fontes de dados (ex: `dio`, `shared_preferences`).
  - Responsável por chamadas HTTP e armazenamento local.
- **Domain Layer**
  - Define as **regras de negócio** e **use cases**.
  - É totalmente desacoplada de frameworks.
- **Presentation Layer**
  - Implementada com `flutter_bloc` para gerenciamento de estado.
  - UI construída com **Widgets** + **Cubit/Bloc** para reagir às mudanças de estado.

---

## 📦 Dependências principais

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) → Gerenciamento de estado reativo.
- [dio](https://pub.dev/packages/dio) → Cliente HTTP para chamadas à API.
- [dart_either](https://pub.dev/packages/dart_either) → Tratamento funcional de erros (Either<L, R>).
- [equatable](https://pub.dev/packages/equatable) → Comparação de objetos por valor.
- [get_it](https://pub.dev/packages/get_it) → Injeção de dependência (Service Locator).
- [shared_preferences](https://pub.dev/packages/shared_preferences) → Armazenamento local simples.

### Dependências de desenvolvimento

- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) → Testes de widgets.
- [mockito](https://pub.dev/packages/mockito) → Criação de mocks.
- [bloc_test](https://pub.dev/packages/bloc_test) → Testes para `Bloc`/`Cubit`.
- [build_runner](https://pub.dev/packages/build_runner) → Geração de código para mocks.
- [flutter_lints](https://pub.dev/packages/flutter_lints) → Regras de lint para manter qualidade do código.

---

## 🧪 Testes e Cobertura

Os testes seguem a estrutura **Arrange → Act → Assert** para clareza e simplicidade.

### Estrutura de testes:

- **Unit Tests** → Cobrem use cases e repositórios.
- **Widget Tests** → Validam comportamento da UI em cenários principais.
- **Bloc/Cubit Tests** → Validam os fluxos de estado.

### Ignorar arquivos desnecessários:

````bash
lcov --remove coverage/lcov.info 'lib/**.g.dart' 'lib/**.freezed.dart' 'lib/main.dart' 'lib/**_mock.dart' -o coverage/lcov.info

### Comando para rodar testes com cobertura:
```bash
flutter test --coverage

### Gerar relatório em HTML
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
````

### 📊 Meta definida:

- O projeto mantém cobertura mínima de 80%. O pipeline de CI falhará caso a cobertura fique abaixo disso.

### ⚙️ Integração Contínua (CI)

- O projeto utiliza GitHub Actions para garantir qualidade do código e confiabilidade dos testes.
- Fluxo da pipeline:
- Instala dependências (flutter pub get).
- Executa análise estática (flutter analyze).
- Roda testes com cobertura (flutter test --coverage).
- Gera relatório em HTML (genhtml).
- Valida que a cobertura está >= 80%, caso contrário o build falha.
- 📄 Arquivo de configuração: .github/workflows/dart.yml
