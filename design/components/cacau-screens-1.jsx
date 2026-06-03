/* global React, Screen, Brand, Btn, Icon, Chip, ProductCard, BottomNav, SectHead, Seal, Stars, Rate, Ph, Avatar */
// ===========================================================================
// Cacau Clube — mock data + screens 1-4
// ===========================================================================

const PRODUCTS = [
  { id: 'p1', name: 'Mel de Cacau Puro', cat: 'Mel de cacau', muni: 'Ji-Paraná', rating: 4.9,
    seal: 'fino', cap: 'mel de cacau', producer: 'Coop. Cacau do Vale' },
  { id: 'p2', name: 'Nibs de Cacau Torrados', cat: 'Nibs', muni: 'Ariquemes', rating: 4.8,
    seal: 'org', cap: 'nibs de cacau', producer: 'Sítio Theobroma' },
  { id: 'p3', name: 'Mel de Cacau Artesanal', cat: 'Mel de cacau', muni: 'Cacoal', rating: 4.7,
    seal: 'agro', cap: 'mel de cacau', producer: 'Família Bonfim' },
  { id: 'p4', name: 'Nibs Crocantes c/ Mel', cat: 'Nibs', muni: 'Jaru', rating: 4.9,
    seal: 'fino', cap: 'nibs + mel', producer: 'Roça Florada' },
  { id: 'p5', name: 'Manteiga de Cacau', cat: 'Manteiga', muni: 'Buritis', rating: 4.6,
    seal: 'org', cap: 'manteiga', producer: 'Coopcacau Buritis' },
  { id: 'p6', name: 'Polpa de Cacau Congelada', cat: 'Polpa', muni: 'Ouro Preto do Oeste', rating: 4.5,
    seal: 'origem', cap: 'polpa / suco', producer: 'Frutos da Amazônia' },
];

const CATEGORIES = [
  { label: 'Tudo', icon: 'spark' },
  { label: 'Mel de cacau', icon: 'droplet' },
  { label: 'Nibs', icon: 'leaf' },
  { label: 'Manteiga', icon: 'package' },
  { label: 'Pó & Liquor', icon: 'flask' },
  { label: 'Polpa', icon: 'cup' },
];

// ---------------------------------------------------------------------------
// 1 · ONBOARDING / SPLASH
// ---------------------------------------------------------------------------
function ScreenOnboarding() {
  return (
    <Screen label="01 · Onboarding">
      <div style={{ flex: 1, position: 'relative', display: 'flex', flexDirection: 'column' }}>
        {/* hero imagery */}
        <Ph tone="farm" cap="fazenda agroflorestal · Rondônia"
          style={{ position: 'absolute', inset: 0, borderRadius: 0 }} />
        <div style={{ position: 'absolute', inset: 0,
          background: 'linear-gradient(0deg, var(--screen-bg) 14%, rgba(251,244,233,0) 52%)' }} />
        <div style={{ position: 'relative', padding: '14px var(--pad)' }}>
          <Brand />
        </div>

        <div style={{ flex: 1 }} />

        {/* content */}
        <div style={{ position: 'relative', padding: '0 var(--pad) 30px', textAlign: 'center' }}>
          <div style={{ display: 'flex', gap: 7, justifyContent: 'center', marginBottom: 20 }}>
            <span style={{ width: 26, height: 6, borderRadius: 99, background: 'var(--accent)' }} />
            <span style={{ width: 6, height: 6, borderRadius: 99, background: 'var(--line-2)' }} />
            <span style={{ width: 6, height: 6, borderRadius: 99, background: 'var(--line-2)' }} />
          </div>
          <div className="serif" style={{ fontSize: 30, fontWeight: 600, lineHeight: 1.12,
            color: 'var(--choco-900)' }}>
            Descubra o cacau<br/>de Rondônia
          </div>
          <p style={{ fontSize: 14.5, color: 'var(--text-2)', lineHeight: 1.5, margin: '12px auto 24px',
            maxWidth: 290 }}>
            Mel de cacau, nibs e muito mais — feitos por produtores e cooperativas da floresta amazônica.
          </p>
          <Btn full icon="arrowR" variant="primary">Começar</Btn>
          <button className="btn ghost full" style={{ marginTop: 10 }}>Já tenho conta</button>
        </div>
      </div>
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 2 · LOGIN / SIGN-UP
// ---------------------------------------------------------------------------
function Field({ icon, label, value, ph, type }) {
  return (
    <label style={{ display: 'block' }}>
      <div style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--text-2)', marginBottom: 7 }}>{label}</div>
      <div className="search" style={{ margin: 0, borderRadius: 'var(--r-sm)', padding: '14px 15px' }}>
        <Icon name={icon} size={18} sw={1.8} style={{ color: 'var(--text-3)' }} />
        <span style={{ flex: 1, fontSize: 14.5, color: value ? 'var(--text)' : 'var(--text-3)' }}>
          {value || ph}
        </span>
        {type === 'pass' && <Icon name="eye" size={18} sw={1.8} style={{ color: 'var(--text-3)' }} />}
      </div>
    </label>
  );
}
function ScreenLogin() {
  return (
    <Screen label="02 · Login">
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '8px var(--pad) 26px' }}>
        <div style={{ textAlign: 'center', marginTop: 22 }}>
          <div style={{ display: 'inline-flex' }}><div className="brand-mark lg" /></div>
          <div className="serif" style={{ fontSize: 27, fontWeight: 600, color: 'var(--choco-900)',
            marginTop: 18 }}>Bem-vindo de volta</div>
          <p style={{ fontSize: 14, color: 'var(--text-2)', margin: '6px 0 0' }}>
            Entre para acompanhar produtores e o Clube.
          </p>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 16, marginTop: 30 }}>
          <Field icon="mail" label="E-mail" value="ana.souza@email.com" />
          <Field icon="lock" label="Senha" value="••••••••" type="pass" />
          <div style={{ textAlign: 'right', fontSize: 12.5, fontWeight: 700,
            color: 'var(--accent-deep)' }}>Esqueci a senha</div>
          <Btn full variant="primary">Entrar</Btn>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '22px 0' }}>
          <div className="divider" style={{ flex: 1 }} />
          <span style={{ fontSize: 12, color: 'var(--text-3)', fontWeight: 600 }}>ou continue com</span>
          <div className="divider" style={{ flex: 1 }} />
        </div>
        <button className="btn ghost full"><Icon name="google" size={19} />Google</button>

        <div style={{ flex: 1 }} />
        <div style={{ textAlign: 'center', fontSize: 13.5, color: 'var(--text-2)' }}>
          Não tem conta? <b style={{ color: 'var(--accent-deep)' }}>Criar conta</b>
        </div>
      </div>
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 3 · HOME / CATÁLOGO
// ---------------------------------------------------------------------------
function ScreenHome() {
  return (
    <Screen label="03 · Home / Catálogo">
      <div className="scr-scroll">
        {/* app bar */}
        <div className="appbar">
          <div>
            <div className="greet">Olá, Ana 🌱</div>
            <div className="loc"><Icon name="pin" size={17} sw={2} style={{ color: 'var(--accent)' }} />Rondônia</div>
          </div>
          <div style={{ display: 'flex', gap: 9 }}>
            <span className="icon-btn"><Icon name="bell" size={20} sw={1.8} /></span>
            <span className="icon-btn" style={{ padding: 0, overflow: 'hidden' }}>
              <Avatar size={42} initials="A" /></span>
          </div>
        </div>

        {/* search */}
        <div className="search" style={{ marginBottom: 'var(--gap)' }}>
          <Icon name="search" size={18} sw={2} />
          <span style={{ flex: 1, fontSize: 14 }}>Buscar mel, nibs, produtores…</span>
          <Icon name="sliders" size={18} sw={2} style={{ color: 'var(--accent-deep)' }} />
        </div>

        {/* categories */}
        <div className="chip-row" style={{ marginBottom: 'var(--gap)' }}>
          {CATEGORIES.map((c, i) => <Chip key={c.label} label={c.label} icon={c.icon} active={i === 0} />)}
        </div>

        {/* hero featured */}
        <div style={{ padding: '0 var(--pad)', marginBottom: 'var(--sect)' }}>
          <div className="hero">
            <Ph tone="cocoa" style={{ position: 'absolute', inset: 0, borderRadius: 0 }} cap="" />
            <div className="hero-grad" />
            <div className="hero-body">
              <span className="hero-kicker">Em destaque · Safra 2026</span>
              <div className="hero-title">Mel de cacau,<br/>o ouro da floresta</div>
              <div style={{ display: 'flex', gap: 7 }}>
                <span className="seal fino"><Icon name="award" size={11} sw={2.2} />Cacau Fino</span>
                <span className="seal origem" style={{ background: 'rgba(255,255,255,.9)' }}>
                  <Icon name="pin" size={11} sw={2.2} />Ji-Paraná</span>
              </div>
            </div>
          </div>
        </div>

        {/* product grid */}
        <SectHead title="Destaques" />
        <div style={{ padding: '12px var(--pad) 18px', display: 'grid',
          gridTemplateColumns: '1fr 1fr', gap: 'var(--gap)' }}>
          {PRODUCTS.slice(0, 4).map((p) => <ProductCard key={p.id} p={p} />)}
        </div>
      </div>
      <BottomNav active="inicio" />
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 4 · BUSCA & FILTROS
// ---------------------------------------------------------------------------
function ResultRow({ p }) {
  return (
    <div className="card" style={{ display: 'flex', gap: 12, padding: 10, alignItems: 'center' }}>
      <Ph tone="cocoa" cap="" style={{ width: 76, height: 76, flex: '0 0 76px', borderRadius: 'var(--r-sm)' }} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="pcard-cat">{p.cat}</div>
        <div className="serif" style={{ fontSize: 15.5, fontWeight: 600, color: 'var(--choco-900)' }}>{p.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
          <span className="muni" style={{ fontSize: 11.5, color: 'var(--text-2)', fontWeight: 600,
            display: 'inline-flex', alignItems: 'center', gap: 4 }}>
            <Icon name="pin" size={12} sw={2} />{p.muni}</span>
          <span className="dot-sep" />
          <Rate value={p.rating} />
        </div>
      </div>
      <Icon name="chevR" size={18} sw={2} style={{ color: 'var(--text-3)' }} />
    </div>
  );
}
function FilterGroup({ label, children }) {
  return (
    <div style={{ marginBottom: 16 }}>
      <div className="flabel">{label}</div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>{children}</div>
    </div>
  );
}
function ScreenSearch() {
  return (
    <Screen label="04 · Busca & Filtros">
      <div className="scr-scroll" style={{ position: 'relative' }}>
        {/* search header */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '4px var(--pad) 12px' }}>
          <span className="icon-btn" style={{ width: 40, height: 40 }}><Icon name="chevL" size={20} sw={2} /></span>
          <div className="search" style={{ margin: 0, flex: 1 }}>
            <Icon name="search" size={18} sw={2} />
            <span style={{ flex: 1, fontSize: 14, color: 'var(--text)' }}>mel de cacau</span>
            <Icon name="x" size={16} sw={2} />
          </div>
        </div>

        {/* applied filters */}
        <div className="chip-row" style={{ marginBottom: 14 }}>
          <Chip label="Filtros" icon="filter" active />
          <Chip label="Mel de cacau" />
          <Chip label="Orgânico" />
          <Chip label="4★+" />
        </div>

        <div style={{ padding: '0 var(--pad)', display: 'flex', alignItems: 'baseline',
          justifyContent: 'space-between', marginBottom: 10 }}>
          <span style={{ fontSize: 13, color: 'var(--text-2)', fontWeight: 600 }}>3 resultados</span>
          <span style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--accent-deep)' }}>Mais bem avaliados</span>
        </div>

        <div style={{ padding: '0 var(--pad)', display: 'flex', flexDirection: 'column', gap: 'var(--gap-sm)' }}>
          {[PRODUCTS[0], PRODUCTS[2], PRODUCTS[3]].map((p) => <ResultRow key={p.id} p={p} />)}
        </div>

        {/* filter bottom sheet */}
        <div className="scrim" />
        <div className="sheet">
          <div className="grab" />
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            marginBottom: 16 }}>
            <span className="serif" style={{ fontSize: 20, fontWeight: 600, color: 'var(--choco-900)' }}>Filtros</span>
            <span style={{ fontSize: 13, fontWeight: 700, color: 'var(--text-3)' }}>Limpar</span>
          </div>
          <FilterGroup label="Subproduto">
            <Chip label="Mel de cacau" active /><Chip label="Nibs" /><Chip label="Manteiga" />
            <Chip label="Pó" /><Chip label="Polpa" />
          </FilterGroup>
          <FilterGroup label="Município">
            <Chip label="Ji-Paraná" active /><Chip label="Ariquemes" /><Chip label="Cacoal" />
            <Chip label="Jaru" />
          </FilterGroup>
          <FilterGroup label="Selo de qualidade">
            <Chip label="Cacau Fino" /><Chip label="Orgânico" active /><Chip label="Agrofloresta" />
          </FilterGroup>
          <FilterGroup label="Avaliação mínima">
            <Chip label="4.5★+" active /><Chip label="4★+" /><Chip label="Qualquer" />
          </FilterGroup>
          <Btn full variant="primary">Ver 3 resultados</Btn>
        </div>
      </div>
    </Screen>
  );
}

Object.assign(window, {
  PRODUCTS, CATEGORIES,
  ScreenOnboarding, ScreenLogin, ScreenHome, ScreenSearch,
});
