import '../data/dtos/origin_lot_dto.dart';
import '../data/dtos/producer_dto.dart';
import '../data/dtos/product_dto.dart';
import '../data/dtos/review_dto.dart';
import '../data/dtos/subscription_dto.dart';
import '../data/dtos/user_dto.dart';
import '../domain/entities/enums.dart';

/// Realistic mock dataset for seeding Firestore.
///
/// 7 Rondônia producers/cooperatives across Ariquemes, Ji-Paraná, Ouro Preto do
/// Oeste, Cacoal, Jaru and Buritis, plus 19 products weighted toward cocoa
/// honey (mel de cacau) and nibs, with one traceability lot per product and a
/// handful of users, reviews and a subscription. All ids are deterministic so
/// re-seeding is idempotent.
abstract final class MockData {
  MockData._();

  // Reference clock so dates are stable across runs.
  static final DateTime _now = DateTime(2026, 5, 20);
  static DateTime _daysAgo(int d) => _now.subtract(Duration(days: d));

  static String _img(String seed) => 'https://picsum.photos/seed/$seed/800/600';

  // Seal / category / type wire keys via the domain enums (no typos).
  static final String _cacauFino = QualitySeal.cacauFino.wireKey;
  static final String _origemRO = QualitySeal.origemRO.wireKey;
  static final String _organico = QualitySeal.organico.wireKey;
  static final String _agrofloresta = QualitySeal.agrofloresta.wireKey;
  static final String _comercioJusto = QualitySeal.comercioJusto.wireKey;

  // ---------------------------------------------------------------------------
  // Producers
  // ---------------------------------------------------------------------------
  static final List<ProducerDto> producers = [
    ProducerDto(
      id: 'prod_cacau_norte',
      name: 'Cooperativa Cacau Norte',
      type: ProducerType.cooperative.wireKey,
      bio: 'Cooperativa de famílias produtoras de cacau em Ariquemes.',
      story:
          'Fundada por 32 famílias agricultoras, a Cacau Norte nasceu para dar '
          'valor ao cacau da região e manter a floresta em pé. Hoje reúne '
          'produtores que cultivam cacau em sistemas agroflorestais às margens '
          'do rio Jamari.',
      municipality: 'Ariquemes',
      geoLat: -9.9136,
      geoLng: -63.0409,
      certifications: const ['Cooperativa registrada OCB', 'Cacau Fino do Brasil'],
      qualitySeals: [_cacauFino, _origemRO, _agrofloresta],
      photoUrls: [_img('cacau-norte-1'), _img('cacau-norte-2')],
      followerCount: 1280,
      rating: 4.8,
    ),
    ProducerDto(
      id: 'prod_mel_floresta',
      name: 'Sítio Mel da Floresta',
      type: ProducerType.producer.wireKey,
      bio: 'Produtor familiar especializado em mel de cacau em Ji-Paraná.',
      story:
          'Seu Antônio e dona Marli transformaram o sítio da família em '
          'referência no mel de cacau. Cada safra é colhida à mão e o mel é '
          'extraído da polpa fresca em poucas horas, preservando o aroma.',
      municipality: 'Ji-Paraná',
      geoLat: -10.8853,
      geoLng: -61.9517,
      certifications: const ['Boas Práticas Agrícolas'],
      qualitySeals: [_cacauFino, _origemRO],
      photoUrls: [_img('mel-floresta-1'), _img('mel-floresta-2')],
      followerCount: 842,
      rating: 4.9,
    ),
    ProducerDto(
      id: 'prod_ouro_verde',
      name: 'Fazenda Ouro Verde',
      type: ProducerType.producer.wireKey,
      bio: 'Cacau orgânico certificado em Ouro Preto do Oeste.',
      story:
          'Na Ouro Verde o cacau cresce sombreado por castanheiras e açaizeiros. '
          'A produção é 100% orgânica, sem agroquímicos, com manejo que protege '
          'as nascentes da propriedade.',
      municipality: 'Ouro Preto do Oeste',
      geoLat: -10.7206,
      geoLng: -62.2159,
      certifications: const ['Certificação Orgânica IBD'],
      qualitySeals: [_organico, _origemRO],
      photoUrls: [_img('ouro-verde-1'), _img('ouro-verde-2')],
      followerCount: 657,
      rating: 4.7,
    ),
    ProducerDto(
      id: 'prod_cacaueiros_cacoal',
      name: 'Associação Cacaueiros de Cacoal',
      type: ProducerType.cooperative.wireKey,
      bio: 'Associação de pequenos produtores de cacau em Cacoal.',
      story:
          'A associação reúne 48 produtores que apostam no comércio justo. '
          'Parte da renda é reinvestida em assistência técnica e em uma unidade '
          'comunitária de processamento de polpa e nibs.',
      municipality: 'Cacoal',
      geoLat: -11.4386,
      geoLng: -61.4472,
      certifications: const ['Comércio Justo (Fairtrade)'],
      qualitySeals: [_comercioJusto, _organico, _origemRO],
      photoUrls: [_img('cacoal-1'), _img('cacoal-2')],
      followerCount: 934,
      rating: 4.6,
    ),
    ProducerDto(
      id: 'prod_boa_esperanca',
      name: 'Sítio Boa Esperança',
      type: ProducerType.producer.wireKey,
      bio: 'Produção artesanal de derivados de cacau em Jaru.',
      story:
          'A família Pereira cultiva cacau há três gerações em Jaru. No sítio, '
          'o cacau fino vira mel, geleia e nibs em pequenos lotes feitos à mão.',
      municipality: 'Jaru',
      geoLat: -10.4389,
      geoLng: -62.4664,
      certifications: const ['Agricultura Familiar (DAP)'],
      qualitySeals: [_cacauFino, _agrofloresta],
      photoUrls: [_img('boa-esperanca-1'), _img('boa-esperanca-2')],
      followerCount: 421,
      rating: 4.7,
    ),
    ProducerDto(
      id: 'prod_amazonia_cacau',
      name: 'Cooperativa Amazônia Cacau',
      type: ProducerType.cooperative.wireKey,
      bio: 'Cacau de sistemas agroflorestais em Buritis.',
      story:
          'A Amazônia Cacau organiza produtores que combinam cacau com espécies '
          'nativas. O modelo agroflorestal regenera áreas degradadas e gera '
          'renda durante o ano todo.',
      municipality: 'Buritis',
      geoLat: -10.2103,
      geoLng: -63.8294,
      certifications: const ['Sistema Agroflorestal Certificado'],
      qualitySeals: [_agrofloresta, _comercioJusto, _origemRO],
      photoUrls: [_img('amazonia-1'), _img('amazonia-2')],
      followerCount: 1103,
      rating: 4.8,
    ),
    ProducerDto(
      id: 'prod_familia_brasil',
      name: 'Família Brasil Cacau',
      type: ProducerType.producer.wireKey,
      bio: 'Cacau silvestre e cosméticos naturais em Ouro Preto do Oeste.',
      story:
          'A Família Brasil aposta no cacau silvestre e em produtos de beleza '
          'feitos com manteiga de cacau prensada na própria propriedade.',
      municipality: 'Ouro Preto do Oeste',
      geoLat: -10.7206,
      geoLng: -62.2159,
      certifications: const ['Cosmético Natural'],
      qualitySeals: [_organico],
      photoUrls: [_img('familia-brasil-1'), _img('familia-brasil-2')],
      followerCount: 389,
      rating: 4.5,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Products (weighted toward cocoa honey + nibs)
  // ---------------------------------------------------------------------------
  static final List<ProductDto> products = [
    // --- Mel de cacau (cocoa honey) ---
    _product('prd_mel_001', 'prod_mel_floresta', 'Mel de Cacau Puro',
        ByproductCategory.cocoaHoney,
        'Néctar dourado extraído da polpa fresca do cacau, sem aditivos. '
        'Doçura suave com notas cítricas.',
        [_cacauFino, _origemRO], 4.9, 37, 2),
    _product('prd_mel_002', 'prod_cacau_norte', 'Mel de Cacau Artesanal',
        ByproductCategory.cocoaHoney,
        'Mel de cacau de sistema agroflorestal, colhido e envasado a frio.',
        [_agrofloresta, _origemRO], 4.7, 21, 6),
    _product('prd_mel_003', 'prod_ouro_verde', 'Mel de Cacau Orgânico',
        ByproductCategory.cocoaHoney,
        'Mel de cacau 100% orgânico, ideal para sobremesas e drinques.',
        [_organico, _origemRO], 4.8, 18, 9),
    _product('prd_mel_004', 'prod_amazonia_cacau', 'Mel de Cacau da Floresta',
        ByproductCategory.cocoaHoney,
        'Produzido por cooperativa em manejo agroflorestal e comércio justo.',
        [_agrofloresta, _comercioJusto], 4.6, 14, 13),
    _product('prd_mel_005', 'prod_boa_esperanca', 'Mel de Cacau Premium',
        ByproductCategory.cocoaHoney,
        'Lote especial de cacau fino, encorpado e aromático.',
        [_cacauFino], 4.9, 11, 16),
    _product('prd_mel_006', 'prod_familia_brasil', 'Mel de Cacau Silvestre',
        ByproductCategory.cocoaHoney,
        'Mel de cacau silvestre colhido na mata, edição limitada.',
        [_organico], 4.5, 8, 20),

    // --- Nibs ---
    _product('prd_nib_001', 'prod_cacau_norte', 'Nibs de Cacau Torrados',
        ByproductCategory.nibs,
        'Pedaços crocantes de amêndoas de cacau torradas, intensos e amargos.',
        [_cacauFino, _origemRO], 4.8, 29, 3),
    _product('prd_nib_002', 'prod_mel_floresta', 'Nibs Crocantes com Mel',
        ByproductCategory.nibs,
        'Nibs levemente adoçados com o próprio mel de cacau da casa.',
        [_cacauFino], 4.7, 16, 7),
    _product('prd_nib_003', 'prod_cacaueiros_cacoal', 'Nibs de Cacau Orgânicos',
        ByproductCategory.nibs,
        'Nibs orgânicos de comércio justo, perfeitos para granola e receitas.',
        [_organico, _comercioJusto], 4.6, 22, 10),
    _product('prd_nib_004', 'prod_ouro_verde', 'Nibs de Cacau Fino',
        ByproductCategory.nibs,
        'Amêndoas selecionadas de cacau fino, fermentação controlada.',
        [_cacauFino, _agrofloresta], 4.8, 13, 12),
    _product('prd_nib_005', 'prod_amazonia_cacau', 'Nibs de Cacau Naturais',
        ByproductCategory.nibs,
        'Nibs naturais sem torra intensa, preservando antioxidantes.',
        [_origemRO], 4.5, 9, 15),

    // --- Outros subprodutos ---
    _product('prd_man_001', 'prod_ouro_verde', 'Manteiga de Cacau Pura',
        ByproductCategory.butter,
        'Manteiga de cacau prensada a frio, aroma natural de chocolate.',
        [_organico], 4.7, 12, 18),
    _product('prd_pwd_001', 'prod_cacau_norte', 'Cacau em Pó 100%',
        ByproductCategory.powder,
        'Cacau em pó puro, sem açúcar, encorpado e aromático.',
        [_origemRO], 4.6, 19, 21),
    _product('prd_plp_001', 'prod_cacaueiros_cacoal', 'Polpa de Cacau Congelada',
        ByproductCategory.pulp,
        'Polpa fresca congelada para sucos, sorvetes e drinques.',
        [_comercioJusto], 4.5, 10, 24),
    _product('prd_jel_001', 'prod_boa_esperanca', 'Geleia de Cacau',
        ByproductCategory.jelly,
        'Geleia artesanal feita com a polpa do cacau, agridoce.',
        [_agrofloresta], 4.6, 7, 27),
    _product('prd_liq_001', 'prod_amazonia_cacau', 'Licor de Cacau Artesanal',
        ByproductCategory.liqueur,
        'Licor encorpado produzido em pequenos lotes com cacau fino.',
        [_cacauFino], 4.7, 9, 30),
    _product('prd_cos_001', 'prod_familia_brasil',
        'Hidratante de Manteiga de Cacau', ByproductCategory.cosmetic,
        'Cosmético natural à base de manteiga de cacau, nutrição intensa.',
        [_organico], 4.4, 6, 33),
    _product('prd_hsk_001', 'prod_cacaueiros_cacoal',
        'Café de Casca de Cacau (Cascara)', ByproductCategory.huskCoffee,
        'Bebida feita da casca do cacau, notas frutadas e baixa cafeína.',
        [_agrofloresta, _comercioJusto], 4.5, 8, 36),
    _product('prd_cho_001', 'prod_mel_floresta', 'Chocolate 70% de Origem',
        ByproductCategory.chocolate,
        'Chocolate de origem única com 70% de cacau fino de Rondônia.',
        [_cacauFino, _origemRO], 4.8, 25, 5),
  ];

  // ---------------------------------------------------------------------------
  // Origin lots (one per product — traceability)
  // ---------------------------------------------------------------------------
  static List<OriginLotDto> get originLots {
    final byId = {for (final p in producers) p.id: p};
    return products.where((p) => p.originLotId != null).map((p) {
      final producer = byId[p.producerId]!;
      final harvest = p.createdAt.subtract(const Duration(days: 30));
      return OriginLotDto(
        id: p.originLotId!,
        producerId: p.producerId,
        municipality: producer.municipality,
        geoLat: producer.geoLat,
        geoLng: producer.geoLng,
        harvestDate: harvest,
        processingNotes:
            'Lote rastreável de ${producer.municipality} (RO), manejo '
            'sombreado e fermentação controlada.',
        timeline: _standardTimeline(harvest),
      );
    }).toList();
  }

  static List<TimelineEventDto> _standardTimeline(DateTime harvest) => [
        TimelineEventDto(
          title: 'Colheita',
          description:
              'Frutos colhidos à mão no ponto ideal de maturação.',
          date: harvest,
        ),
        TimelineEventDto(
          title: 'Fermentação',
          description:
              'Sementes fermentadas em caixas de madeira por 6 dias.',
          date: harvest.add(const Duration(days: 2)),
        ),
        TimelineEventDto(
          title: 'Secagem',
          description: 'Secagem lenta ao sol em terreiro suspenso.',
          date: harvest.add(const Duration(days: 9)),
        ),
        TimelineEventDto(
          title: 'Processamento e envase',
          description: 'Seleção, processamento e envase do produto final.',
          date: harvest.add(const Duration(days: 16)),
        ),
      ];

  // ---------------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------------
  static final List<UserDto> users = [
    UserDto(
      uid: 'user_ana',
      name: 'Ana Souza',
      email: 'ana.souza@example.com',
      photoUrl: _img('user-ana'),
      subscriptionTier: SubscriptionTier.paid.wireKey,
      followingProducerIds: const ['prod_mel_floresta', 'prod_cacau_norte'],
      createdAt: _daysAgo(120),
    ),
    UserDto(
      uid: 'user_joao',
      name: 'João Lima',
      email: 'joao.lima@example.com',
      photoUrl: _img('user-joao'),
      subscriptionTier: SubscriptionTier.free.wireKey,
      followingProducerIds: const ['prod_amazonia_cacau'],
      createdAt: _daysAgo(64),
    ),
  ];

  static final List<SubscriptionDto> subscriptions = [
    SubscriptionDto(
      userId: 'user_ana',
      tier: SubscriptionTier.paid.wireKey,
      status: SubscriptionStatus.active.wireKey,
      startedAt: _daysAgo(40),
      renewsAt: _now.add(const Duration(days: 20)),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Reviews
  // ---------------------------------------------------------------------------
  static final List<ReviewDto> reviews = [
    _review('rev_001', 'prd_mel_001', 'user_ana', 'Ana Souza', 5,
        'O melhor mel de cacau que já provei. Aroma incrível!', 4),
    _review('rev_002', 'prd_mel_001', 'user_joao', 'João Lima', 5,
        'Doçura na medida, uso no café da manhã todo dia.', 9),
    _review('rev_003', 'prd_nib_001', 'user_ana', 'Ana Souza', 5,
        'Nibs super crocantes, ótimos na granola.', 6),
    _review('rev_004', 'prd_nib_001', 'user_joao', 'João Lima', 4,
        'Bem torrados e intensos. Recomendo para receitas.', 11),
    _review('rev_005', 'prd_mel_003', 'user_ana', 'Ana Souza', 5,
        'Orgânico e saboroso, dá pra sentir a qualidade.', 7),
    _review('rev_006', 'prd_cho_001', 'user_joao', 'João Lima', 5,
        'Chocolate de origem sensacional, 70% equilibrado.', 3),
    _review('rev_007', 'prd_nib_003', 'user_ana', 'Ana Souza', 4,
        'Gostei do comércio justo por trás do produto.', 12),
    _review('rev_008', 'prd_mel_002', 'user_joao', 'João Lima', 5,
        'Mel artesanal maravilhoso, embalagem caprichada.', 14),
    _review('rev_009', 'prd_man_001', 'user_ana', 'Ana Souza', 5,
        'Manteiga de cacau pura, cheiro de chocolate de verdade.', 17),
    _review('rev_010', 'prd_liq_001', 'user_joao', 'João Lima', 4,
        'Licor encorpado, ótimo para harmonizar sobremesas.', 28),
    _review('rev_011', 'prd_jel_001', 'user_ana', 'Ana Souza', 5,
        'Geleia agridoce diferente de tudo, adorei.', 25),
    _review('rev_012', 'prd_nib_004', 'user_joao', 'João Lima', 5,
        'Cacau fino de verdade, fermentação no ponto.', 11),
  ];

  // --- builders ---------------------------------------------------------------

  static ProductDto _product(
    String id,
    String producerId,
    String name,
    ByproductCategory category,
    String description,
    List<String> seals,
    double rating,
    int reviewCount,
    int createdDaysAgo,
  ) {
    return ProductDto(
      id: id,
      producerId: producerId,
      name: name,
      byproductCategory: category.wireKey,
      description: description,
      photoUrls: [_img(id)],
      qualitySeals: seals,
      originLotId: 'lot_$id',
      rating: rating,
      reviewCount: reviewCount,
      createdAt: _daysAgo(createdDaysAgo),
    );
  }

  static ReviewDto _review(
    String id,
    String productId,
    String userId,
    String userName,
    int rating,
    String text,
    int createdDaysAgo,
  ) {
    return ReviewDto(
      id: id,
      productId: productId,
      userId: userId,
      rating: rating,
      text: text,
      createdAt: _daysAgo(createdDaysAgo),
      userName: userName,
      userPhotoUrl: _img('user-${userId.split('_').last}'),
    );
  }
}
