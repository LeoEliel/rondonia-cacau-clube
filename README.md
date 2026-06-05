# Rondônia Cacau Clube

Um app de vitrine + rastreabilidade para **subprodutos** do cacau do estado de
Rondônia, Brasil, com foco em produtos além do chocolate: **mel de cacau** e
**nibs de cacau**. O catálogo de subprodutos **não é e-commerce** — sem carrinho,
checkout ou preços de produto. Os consumidores descobrem os subprodutos do cacau
de Rondônia, veem quem os produziu e de onde vêm (rastreabilidade de origem
completa), seguem produtores/cooperativas e entram no **Clube do Cacau**, que tem
um nível premium opcional vendido como compra dentro do app (in-app purchase).

Idioma da interface: **pt-BR**. Código, comentários e identificadores: **inglês**.
Este protótipo **não tem recursos de IA e não usa chaves de API de terceiros**.

O projeto Flutter fica em [`app/`](app/).

---

## Stack tecnológica

- **Flutter** (stable) + Dart, com null-safety.
- **GetX** (`get`) para gerenciamento de estado, injeção de dependências e roteamento.
- **Firebase**: Core, Auth, Cloud Firestore, Storage, Analytics, Crashlytics.
- **google_fonts** para as famílias tipográficas Lora + Hanken Grotesk.
- **shared_preferences** para estado local leve (ex.: tema).
- **dartz** para o tipo funcional de erro `Result` (Either).
- **flutter_map** + **latlong2** para o mapa de origem do OpenStreetMap (sem chave de API / cobrança).
- **url_launcher** para links de contato externos (ex.: WhatsApp).
- **purchases_flutter** (RevenueCat) para as compras no app do nível premium do Clube do Cacau.

## Arquitetura — SOLID + Clean Architecture

```
app/lib/
├── app/            # widget raiz GetMaterialApp
├── core/           # transversal: tema, rotas, bindings, constantes, widgets
│   ├── theme/      # design tokens → cores, espaçamento, raios, tipografia, temas
│   ├── routes/     # AppRoutes (nomes) + AppPages (tabela GetPage)
│   ├── bindings/   # InitialBinding (DI de toda a app)
│   ├── controllers/# ThemeController
│   ├── session/    # SessionController (identidade guiada por auth + estado de follows)
│   ├── constants/  # strings pt-BR, caminhos de assets
│   └── widgets/    # widgets compartilhados
├── domain/         # Dart puro: entidades, INTERFACES de repositório, casos de uso
│   └── core/       # Failure, Result (Either), contrato UseCase
├── data/           # IMPLEMENTAÇÕES de repositório, data sources, DTOs, mappers
└── presentation/   # telas, GetxControllers (view-models), Bindings
    ├── shell/                          # shell da app + navegação inferior
    ├── onboarding/  auth/              # slides de introdução, login / cadastro
    ├── home/  search/  product_detail/ # catálogo, filtros, rastreabilidade
    ├── producer/  reviews/             # perfis de produtor, avaliações
    └── club/  profile/                 # Clube do Cacau + conta
```

Regras de camadas:
- **domain** não depende de nada do Flutter/Firebase/GetX — abstrações em Dart puro.
- **data** implementa as interfaces de repositório do domínio (o Firebase vive só aqui).
- **presentation** depende das abstrações do domínio; os controllers recebem os
  casos de uso através dos **Bindings** do GetX (inversão de dependência).
- Os erros cruzam as fronteiras como um `Result<T>` (`Either<Failure, T>`), nunca
  como exceções lançadas.

## Sistema de design

A única fonte de verdade é o [`design_tokens.md`](design_tokens.md) na raiz do
repositório; o tema Material 3 em tons quentes de cacau (claro **e** escuro) é
gerado a partir dele em `app/lib/core/theme/` (`app_colors`, `app_typography`,
`app_spacing`, `app_radii`, `app_elevation`, `app_seals`):

- **Superfícies**: creme `#FBF4E9`, branco, cremes suaves.
- **Cacau**: choco `#241208 / #2E1C12 / #3A2317 / #5A3522 / #6B3F23`, caramelo `#B5703A`.
- **Acento âmbar**: `#D98B1F` (+ profundo `#C0741A`, suave `#F3C95E`, tom `#FBEFD2`).
- **Acento verde floresta**: `#3F7A43` (+ profundo `#356637`, suave `#6BA45F`, tom `#E6F0DF`).
- **Tipografia**: Lora (serifada — display/títulos/nomes de produto/história em
  itálico) + Hanken Grotesk (sem serifa — corpo/meta/overline/selo).
- **Raios**: 8 / 12 / 18 / 26 / 32 / pill. **Espaçamento** (base 4): 4 / 8 / 12 / 16 /
  20 / 26, mais os semânticos `pad 20 · gap 14 · gapSm 9 · sect 26 · cardPad 15`.
- **Elevação**: sombras com tom de cacau `e1 / e2 / e3`. Mapa de cores dos **selos de qualidade**.

---

## Primeiros passos

```bash
cd app
flutter pub get
flutter run         # escolha um dispositivo (web/android/ios)
flutter test        # testes unitários + de widget
flutter analyze
```

### Modos de execução

O app roda em dois modos, selecionados inteiramente por `--dart-define` — o mesmo
código de binding atende a ambos (veja `lib/core/bindings/data_binding.dart`):

- **DEMO** (offline, dados mock em memória; sem necessidade de backend Firebase ou
  chaves de loja). As compras do Clube do Cacau caem para um mock que apenas
  alterna o nível, então o fluxo "Assinar o Clube" funciona sem o RevenueCat. Este
  Codespace expõe **apenas a porta 8080**:

  ```bash
  flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 --dart-define=DEMO=true
  ```

- **Não-DEMO** (Firebase real). No **mobile**, as compras do Clube do Cacau usam o
  RevenueCat; passe a chave em tempo de build (nunca a comite). Na **web**, as
  compras usam o mesmo fallback de nível do DEMO (o RevenueCat é só para mobile):

  ```bash
  flutter run --dart-define=REVENUECAT_API_KEY=goog_xxx        # Android/iOS
  flutter run -d web-server --web-port 8080                    # web (sem chave necessária)
  ```

O SDK do RevenueCat só é configurado em builds **nativos** não-DEMO com uma chave
não vazia; web/DEMO nunca o tocam.

### Configuração do Firebase

Os arquivos de configuração do Firebase contêm as chaves de API de cliente do
projeto e **não são commitados** (este repositório é público). Eles estão no
.gitignore; o repositório inclui templates de exemplo no lugar:

- `app/lib/firebase_options.dart.example`
- `app/android/app/google-services.json.example`

Para conectar seu próprio projeto Firebase, execute:

```bash
cd app
flutterfire configure
```

Isso regenera os arquivos reais ignorados (`lib/firebase_options.dart`,
`android/app/google-services.json` e o `GoogleService-Info.plist` do iOS/macOS).
Como alternativa, copie cada `*.example` para o nome real do arquivo e preencha
seus valores.

Produtos Firebase necessários: Authentication (E-mail + Google), Cloud Firestore,
Storage. A coleta do Crashlytics fica desabilitada em builds de debug.

> **Nota sobre chaves de API:** as chaves de API de *cliente* do Firebase não são
> segredos clássicos — o acesso é garantido pelas Firebase Security Rules,
> restrições de chave de API e App Check, não por ocultar a chave. Ainda assim as
> mantemos fora deste repositório público por higiene. Como as chaves ficaram
> brevemente públicas, restrinja/rotacione-as no Google Cloud Console e bloqueie
> as Security Rules antes de qualquer uso real.

### Regras de segurança

O `app/firestore.rules` deixa o catálogo (producers/products/origin_lots) com
leitura pública, permite que usuários autenticados criem suas próprias avaliações
e ajustem a contagem de seguidores de um produtor, e mantém o perfil/assinatura de
cada usuário privado ao seu dono.

---

## Modelo de dados & seeding

Coleções do Firestore (formatos em `app/lib/data/dtos/`):

| Coleção | Campos principais |
|---|---|
| `users` | name, email, photoUrl, subscriptionTier, followingProducerIds[], createdAt |
| `producers` | name, type (producer\|cooperative), bio, story, municipality, geo, certifications[], qualitySeals[], photoUrls[], followerCount, rating |
| `products` | producerId, name, byproductCategory, description, photoUrls[], qualitySeals[], originLotId, rating, reviewCount, createdAt |
| `origin_lots` | producerId, municipality, geo, harvestDate, processingNotes, timeline[] |
| `reviews` | productId, userId, rating, text, createdAt, userName, userPhotoUrl |
| `subscriptions` | tier, status, startedAt, renewsAt (doc id = userId) |

O domínio é puro: entidades em `lib/domain/entities/`, interfaces de repositório em
`lib/domain/repositories/`, casos de uso em `lib/domain/usecases/` (todos retornando
`Result<T>`). O Firestore vive apenas em `lib/data/` (mappers DTO ↔ entidade, data
sources, implementações de repositório), conectado via GetX em
`lib/core/bindings/data_binding.dart`.

### Popular dados mock (seed)

Um seeder executável popula o Firestore com 7 produtores/cooperativas de Rondônia
(Ariquemes, Ji-Paraná, Ouro Preto do Oeste, Cacoal, Jaru, Buritis), 19 produtos
com ênfase em mel de cacau + nibs, um lote de rastreabilidade por produto, além de
usuários, avaliações e uma assinatura de exemplo. Os ids são determinísticos, então
reexecutar sobrescreve em vez de duplicar.

```bash
cd app
flutter run -t lib/seed/seed_firestore.dart -d chrome   # ou outro dispositivo
```

Execute-o enquanto o banco permite escritas não autenticadas (Firestore *test mode*
/ suas regras de dev), depois faça o deploy das `firestore.rules` bloqueadas.

---

## Marcos (milestones)

- [x] **M1 — Fundação**: scaffold de Clean Architecture, GetX (controllers /
  bindings / rotas), integração do Firebase, tema Material 3 em tons quentes de
  cacau (claro+escuro), shell da app + navegação inferior (Início · Buscar ·
  Clube · Perfil).
- [x] **M2 — Domínio + Dados + Seed**: entidades, interfaces de repositório e
  casos de uso (domínio puro com `Result`); camada de dados Firestore (DTOs,
  mappers, data sources, implementações de repositório) conectada via GetX
  bindings; script de seed de dados mock + `firestore.rules`; testes unitários
  de casos de uso.
- [x] **M3 — UI de Catálogo + Rastreabilidade**: Home/Catálogo, Busca & Filtros e
  Detalhe do Produto com a linha do tempo de rastreabilidade e um mapa de origem
  real do **OpenStreetMap** (flutter_map, sem chave de API), além de componentes
  reutilizáveis.
- [x] **M4 — UI de Produtores + Avaliações**: perfis de produtor/cooperativa,
  follow, notas & avaliações, selos de qualidade.
- [x] **M5 — Clube do Cacau + Auth**: onboarding, login/cadastro (e-mail +
  Google), aba Perfil e a tela do Clube do Cacau com níveis de assinatura.
- [x] **M9 — Compras no app do Clube do Cacau**: compras reais com RevenueCat
  (purchases_flutter) para o nível premium do Clube por trás de um seam de
  domínio, com um fallback de tier/web para que o fluxo funcione em demo, na web
  e em builds sem chave.

**Polimento & robustez** (pós-M5): tema claro **e** escuro aplicado em todas as
telas, auditoria de design tokens e validação das Firestore security rules contra
o backend real.

Construído de forma incremental; cada marco é commitado e enviado separadamente.
