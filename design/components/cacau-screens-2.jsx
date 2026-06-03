/* global React, Screen, Brand, Btn, Icon, Chip, ProductCard, BottomNav, SectHead, Seal, Stars, Rate, Ph, Avatar, TimelineItem, PRODUCTS */
// ===========================================================================
// Cacau Clube — screens 5-8
// ===========================================================================

// ---------------------------------------------------------------------------
// 5 · PRODUCT DETAIL (traceability + map)
// ---------------------------------------------------------------------------
function InfoTile({ icon, label, value }) {
  return (
    <div className="card" style={{ flex: 1, padding: '12px 13px', display: 'flex', gap: 10,
      alignItems: 'center' }}>
      <span style={{ width: 34, height: 34, borderRadius: 10, flex: '0 0 34px',
        background: 'var(--accent-tint)', color: 'var(--accent-deep)', display: 'flex',
        alignItems: 'center', justifyContent: 'center' }}>
        <Icon name={icon} size={18} sw={2} /></span>
      <div style={{ minWidth: 0 }}>
        <div style={{ fontSize: 10.5, fontWeight: 700, letterSpacing: '.4px', textTransform: 'uppercase',
          color: 'var(--text-3)' }}>{label}</div>
        <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--choco-900)' }}>{value}</div>
      </div>
    </div>
  );
}
function ScreenDetail() {
  return (
    <Screen label="05 · Detalhe do Produto">
      <div className="scr-scroll">
        {/* photo */}
        <div style={{ position: 'relative', height: 290, flex: '0 0 290px' }}>
          <Ph tone="cocoa" cap="foto do produto · mel de cacau" style={{ position: 'absolute', inset: 0, borderRadius: 0 }} />
          <div style={{ position: 'absolute', top: 8, left: 0, right: 0, padding: '0 var(--pad)',
            display: 'flex', justifyContent: 'space-between' }}>
            <span className="icon-btn"><Icon name="chevL" size={20} sw={2} /></span>
            <div style={{ display: 'flex', gap: 9 }}>
              <span className="icon-btn"><Icon name="share" size={19} sw={1.8} /></span>
              <span className="icon-btn"><Icon name="heart" size={19} sw={1.8} /></span>
            </div>
          </div>
          <div style={{ position: 'absolute', bottom: 12, left: 0, right: 0, display: 'flex',
            justifyContent: 'center', gap: 6 }}>
            {[0,1,2].map(i => <span key={i} style={{ width: i===0?20:6, height: 6, borderRadius: 99,
              background: i===0 ? '#fff' : 'rgba(255,255,255,.55)' }} />)}
          </div>
        </div>

        {/* body */}
        <div style={{ padding: 'var(--pad)', display: 'flex', flexDirection: 'column', gap: 'var(--gap)' }}>
          <div>
            <div className="pcard-cat" style={{ marginBottom: 4 }}>Mel de cacau</div>
            <div className="serif" style={{ fontSize: 26, fontWeight: 600, lineHeight: 1.12,
              color: 'var(--choco-900)' }}>Mel de Cacau Puro</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 8 }}>
              <Stars value={4.9} size={15} />
              <span style={{ fontSize: 13, fontWeight: 700, color: 'var(--choco-800)' }}>4.9</span>
              <span style={{ fontSize: 12.5, color: 'var(--text-3)' }}>· 128 avaliações</span>
            </div>
          </div>

          <div style={{ display: 'flex', gap: 7, flexWrap: 'wrap' }}>
            <Seal kind="fino" /><Seal kind="org" /><Seal kind="origem" />
          </div>

          <p style={{ fontSize: 14.5, color: 'var(--text-2)', lineHeight: 1.55, margin: 0 }}>
            Líquido dourado extraído da polpa fresca do cacau, sem aquecimento. Notas frutadas e
            cítricas, naturalmente doce. Ideal para regar frutas, queijos e drinks.
          </p>

          {/* traceability */}
          <div style={{ marginTop: 6 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
              <Icon name="pin" size={18} sw={2} style={{ color: 'var(--accent-deep)' }} />
              <span className="serif" style={{ fontSize: 19, fontWeight: 600, color: 'var(--choco-900)' }}>Rastreabilidade</span>
            </div>

            {/* producer link */}
            <div className="card" style={{ padding: 12, display: 'flex', alignItems: 'center', gap: 12,
              marginBottom: 12 }}>
              <Avatar size={48} initials="CV" />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 10.5, fontWeight: 700, letterSpacing: '.4px',
                  textTransform: 'uppercase', color: 'var(--green-deep)' }}>Cooperativa</div>
                <div className="serif" style={{ fontSize: 16, fontWeight: 600, color: 'var(--choco-900)' }}>Cacau do Vale</div>
                <div style={{ fontSize: 12, color: 'var(--text-2)' }}>Ji-Paraná · RO</div>
              </div>
              <button className="btn ghost sm">Ver perfil</button>
            </div>

            {/* lot tiles */}
            <div style={{ display: 'flex', gap: 'var(--gap-sm)', marginBottom: 14 }}>
              <InfoTile icon="package" label="Lote" value="MEL-0142" />
              <InfoTile icon="clock" label="Colheita" value="Mar 2026" />
            </div>

            {/* timeline */}
            <div className="card" style={{ padding: '16px 16px 14px', marginBottom: 14 }}>
              <div className="ds-lbl" style={{ marginBottom: 14, color: 'var(--text-3)' }}>Da floresta ao pote</div>
              <div className="tl">
                <TimelineItem icon="leaf" done title="Colheita" when="12 mar · Ji-Paraná"
                  desc="Frutos maduros colhidos à mão em sistema agroflorestal." />
                <TimelineItem icon="droplet" done title="Extração da polpa" when="13 mar"
                  desc="Mel drenado da polpa fresca, a frio, sem prensagem." />
                <TimelineItem icon="flask" done title="Pasteurização leve" when="14 mar"
                  desc="Estabilização suave preservando aroma e cor." />
                <TimelineItem icon="package" last title="Envase artesanal" when="15 mar"
                  desc="Envasado e selado na sede da cooperativa." />
              </div>
            </div>

            {/* map */}
            <div className="mapblock" style={{ height: 150 }}>
              <div className="mappin">
                <span className="pin-cap"><Icon name="pin" size={13} sw={2.2}
                  style={{ color: 'var(--accent-deep)' }} />Ji-Paraná, RO</span>
                <span className="pin-drop" />
              </div>
              <span style={{ position: 'absolute', bottom: 8, left: 10, fontSize: 9.5,
                fontFamily: 'ui-monospace,monospace', color: 'var(--green-deep)',
                background: 'rgba(255,255,255,.7)', padding: '2px 6px', borderRadius: 99 }}>
                mapa · município de origem</span>
            </div>
          </div>

          <Btn full variant="wa" icon="wa">Falar com o produtor</Btn>
          <div style={{ textAlign: 'center', fontSize: 11.5, color: 'var(--text-3)', marginTop: -4 }}>
            Vitrine de origem — sem venda no app.
          </div>
        </div>
      </div>
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 6 · PRODUCER / COOPERATIVE PROFILE
// ---------------------------------------------------------------------------
function ScreenProducer() {
  return (
    <Screen label="06 · Perfil do Produtor">
      <div className="scr-scroll">
        {/* cover */}
        <div style={{ position: 'relative', height: 150, flex: '0 0 150px' }}>
          <Ph tone="farm" cap="capa · roça de cacau" style={{ position: 'absolute', inset: 0, borderRadius: 0 }} />
          <div style={{ position: 'absolute', top: 8, left: 0, right: 0, padding: '0 var(--pad)',
            display: 'flex', justifyContent: 'space-between' }}>
            <span className="icon-btn"><Icon name="chevL" size={20} sw={2} /></span>
            <span className="icon-btn"><Icon name="share" size={19} sw={1.8} /></span>
          </div>
        </div>

        <div style={{ padding: '0 var(--pad) var(--pad)', marginTop: -34 }}>
          {/* avatar + identity */}
          <div style={{ display: 'flex', alignItems: 'flex-end', gap: 14, marginBottom: 14 }}>
            <div style={{ borderRadius: '50%', border: '3px solid var(--screen-bg)' }}>
              <Avatar size={80} initials="CV" />
            </div>
            <div style={{ paddingBottom: 4 }}>
              <span className="seal org" style={{ marginBottom: 6, display: 'inline-flex' }}>
                <Icon name="check" size={11} sw={2.2} />Cooperativa</span>
            </div>
          </div>
          <div className="serif" style={{ fontSize: 25, fontWeight: 600, color: 'var(--choco-900)' }}>
            Cooperativa Cacau do Vale</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7, fontSize: 13,
            color: 'var(--text-2)', marginTop: 4 }}>
            <Icon name="pin" size={14} sw={2} />Ji-Paraná, Rondônia
            <span className="dot-sep" /><Rate value={4.9} count={210} />
          </div>

          {/* stats + follow */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 14, margin: '16px 0' }}>
            <div>
              <div style={{ fontFamily: 'Lora,serif', fontSize: 19, fontWeight: 700,
                color: 'var(--choco-900)' }}>1.240</div>
              <div style={{ fontSize: 11.5, color: 'var(--text-3)', fontWeight: 600 }}>Seguidores</div>
            </div>
            <div className="divider" style={{ width: 1, height: 30 }} />
            <div>
              <div style={{ fontFamily: 'Lora,serif', fontSize: 19, fontWeight: 700,
                color: 'var(--choco-900)' }}>8</div>
              <div style={{ fontSize: 11.5, color: 'var(--text-3)', fontWeight: 600 }}>Produtos</div>
            </div>
            <div style={{ flex: 1 }} />
            <Btn variant="primary" icon="plus" sm>Seguir</Btn>
          </div>

          {/* story */}
          <div className="ds-lbl" style={{ color: 'var(--text-3)', marginBottom: 8 }}>Nossa história</div>
          <p className="serif" style={{ fontSize: 15.5, lineHeight: 1.55, color: 'var(--choco-800)',
            margin: '0 0 16px', fontStyle: 'italic' }}>
            “Reunimos 32 famílias agricultoras do Vale do Jamari. Cultivamos cacau na sombra da
            floresta em pé e transformamos cada fruto — do mel aos nibs — com respeito à terra.”
          </p>

          {/* certifications */}
          <div className="ds-lbl" style={{ color: 'var(--text-3)', marginBottom: 8 }}>Certificações & selos</div>
          <div style={{ display: 'flex', gap: 7, flexWrap: 'wrap', marginBottom: 18 }}>
            <Seal kind="fino" /><Seal kind="org" /><Seal kind="agro" /><Seal kind="justo" />
          </div>

          {/* gallery */}
          <div className="ds-lbl" style={{ color: 'var(--text-3)', marginBottom: 8 }}>Galeria</div>
          <div style={{ display: 'flex', gap: 'var(--gap-sm)', marginBottom: 20 }}>
            <Ph tone="farm" cap="" style={{ flex: 1, height: 84, borderRadius: 'var(--r-sm)' }} />
            <Ph tone="cocoa" cap="" style={{ flex: 1, height: 84, borderRadius: 'var(--r-sm)' }} />
            <Ph tone="farm" cap="" style={{ flex: 1, height: 84, borderRadius: 'var(--r-sm)' }} />
          </div>

          {/* products */}
          <SectHead title="Produtos" action="8 itens" />
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--gap)', marginTop: 12 }}>
            {[PRODUCTS[0], PRODUCTS[3]].map((p) => <ProductCard key={p.id} p={p} />)}
          </div>
        </div>
      </div>
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 7 · COCOA CLUB (subscription)
// ---------------------------------------------------------------------------
function Feat({ children, dark }) {
  return (
    <div className="feat" style={{ marginTop: 11 }}>
      <span className="fk"><Icon name="check" size={16} sw={2.4} /></span>
      <span style={{ color: dark ? '#E9DBC4' : 'var(--text-2)' }}>{children}</span>
    </div>
  );
}
function ScreenClub() {
  return (
    <Screen label="07 · Clube do Cacau">
      <div className="scr-scroll">
        <div style={{ padding: 'var(--pad)', display: 'flex', flexDirection: 'column' }}>
          <div style={{ textAlign: 'center', marginBottom: 4 }}>
            <span style={{ display: 'inline-flex', width: 56, height: 56, borderRadius: 18,
              background: 'var(--accent-tint)', color: 'var(--accent-deep)', alignItems: 'center',
              justifyContent: 'center' }}>
              <Icon name="crown" size={28} sw={1.8} fill /></span>
            <div className="serif" style={{ fontSize: 26, fontWeight: 600, color: 'var(--choco-900)',
              marginTop: 12 }}>Clube do Cacau</div>
            <p style={{ fontSize: 14, color: 'var(--text-2)', margin: '6px auto 0', maxWidth: 280,
              lineHeight: 1.5 }}>
              Histórias de quem planta, lançamentos antecipados e conteúdo curado da floresta.
            </p>
          </div>

          {/* tiers */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--gap)', margin: '20px 0 18px' }}>
            <div className="tier">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                <span className="tier-name">Gratuito</span>
                <span className="tier-tag" style={{ color: 'var(--text-3)' }}>Plano atual</span>
              </div>
              <Feat>Explorar o catálogo e a origem</Feat>
              <Feat>Seguir produtores e cooperativas</Feat>
              <Feat>Avaliar produtos</Feat>
            </div>

            <div className="tier pro">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span className="tier-name" style={{ color: '#fff' }}>Clube</span>
                <span className="tier-tag" style={{ background: 'var(--accent)', color: '#fff',
                  padding: '5px 11px', borderRadius: 99 }}>Recomendado</span>
              </div>
              <div style={{ fontSize: 13, color: 'var(--amber-soft)', fontWeight: 600, marginTop: 4 }}>
                Tudo do gratuito, e mais:</div>
              <Feat dark>Histórias exclusivas dos produtores</Feat>
              <Feat dark>Acesso antecipado a lançamentos & safras</Feat>
              <Feat dark>Conteúdo curado: receitas e harmonizações</Feat>
              <Feat dark>Selo de Membro no seu perfil</Feat>
              <button className="btn primary full" style={{ marginTop: 18 }}>Assinar o Clube</button>
              <div style={{ textAlign: 'center', fontSize: 11, color: 'rgba(244,232,212,.7)',
                marginTop: 8 }}>Protótipo — sem cobrança real.</div>
            </div>
          </div>

          {/* member feed preview */}
          <SectHead title="Do Clube" action="" />
          <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--gap-sm)', marginTop: 12 }}>
            <div className="card" style={{ display: 'flex', gap: 12, padding: 10, alignItems: 'center' }}>
              <Ph tone="farm" cap="" style={{ width: 72, height: 72, flex: '0 0 72px', borderRadius: 'var(--r-sm)' }} />
              <div style={{ flex: 1 }}>
                <span className="seal fino"><Icon name="lock" size={11} sw={2.2} />Exclusivo</span>
                <div className="serif" style={{ fontSize: 15, fontWeight: 600, color: 'var(--choco-900)',
                  marginTop: 5 }}>A safra do mel em Ji-Paraná</div>
                <div style={{ fontSize: 12, color: 'var(--text-2)', marginTop: 2 }}>História · 4 min</div>
              </div>
            </div>
            <div className="card" style={{ display: 'flex', gap: 12, padding: 10, alignItems: 'center' }}>
              <Ph tone="cocoa" cap="" style={{ width: 72, height: 72, flex: '0 0 72px', borderRadius: 'var(--r-sm)' }} />
              <div style={{ flex: 1 }}>
                <span className="seal fino"><Icon name="lock" size={11} sw={2.2} />Exclusivo</span>
                <div className="serif" style={{ fontSize: 15, fontWeight: 600, color: 'var(--choco-900)',
                  marginTop: 5 }}>Nibs: do fruto à crocância</div>
                <div style={{ fontSize: 12, color: 'var(--text-2)', marginTop: 2 }}>Receita · 6 min</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <BottomNav active="clube" />
    </Screen>
  );
}

// ---------------------------------------------------------------------------
// 8 · REVIEWS
// ---------------------------------------------------------------------------
const REVIEWS = [
  { n: 'Marina L.', i: 'ML', r: 5, d: 'há 3 dias', t: 'O mel de cacau é surreal — frutado e nada enjoativo. Adorei saber de qual cooperativa veio.' },
  { n: 'Rafael T.', i: 'RT', r: 5, d: 'há 1 semana', t: 'Nibs crocantes e aromáticos. A linha do tempo da origem dá muita confiança.' },
  { n: 'Júlia M.', i: 'JM', r: 4, d: 'há 2 semanas', t: 'Produto ótimo e história linda. Queria mais fotos da fazenda no app.' },
];
function BarRow({ n, pct }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <span style={{ fontSize: 11.5, fontWeight: 700, color: 'var(--text-2)', width: 8 }}>{n}</span>
      <Icon name="star" size={11} fill style={{ color: 'var(--amber)' }} />
      <div style={{ flex: 1, height: 6, borderRadius: 99, background: 'var(--surface-3)' }}>
        <div style={{ width: pct + '%', height: '100%', borderRadius: 99, background: 'var(--accent)' }} />
      </div>
    </div>
  );
}
function ScreenReviews() {
  return (
    <Screen label="08 · Avaliações">
      <div className="scr-scroll">
        <div className="topbar" style={{ padding: '4px var(--pad) 8px' }}>
          <span className="icon-btn" style={{ width: 40, height: 40 }}><Icon name="chevL" size={20} sw={2} /></span>
          <span className="title">Avaliações</span>
          <span style={{ width: 40 }} />
        </div>

        <div style={{ padding: '0 var(--pad)' }}>
          {/* aggregate */}
          <div className="card" style={{ padding: 16, display: 'flex', gap: 18, alignItems: 'center',
            marginBottom: 'var(--gap)' }}>
            <div style={{ textAlign: 'center' }}>
              <div className="serif" style={{ fontSize: 40, fontWeight: 700, lineHeight: 1,
                color: 'var(--choco-900)' }}>4.9</div>
              <Stars value={5} size={13} />
              <div style={{ fontSize: 11.5, color: 'var(--text-3)', marginTop: 4 }}>128 avaliações</div>
            </div>
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 5 }}>
              <BarRow n={5} pct={88} /><BarRow n={4} pct={9} /><BarRow n={3} pct={2} />
              <BarRow n={2} pct={1} /><BarRow n={1} pct={0} />
            </div>
          </div>

          {/* write a review */}
          <div className="card" style={{ padding: 16, marginBottom: 'var(--sect)',
            background: 'var(--accent-tint)', borderColor: 'var(--amber-soft)' }}>
            <div className="serif" style={{ fontSize: 17, fontWeight: 600, color: 'var(--choco-900)' }}>Como foi sua experiência?</div>
            <div className="star-input" style={{ margin: '12px 0 14px', justifyContent: 'center' }}>
              {[0,1,2,3,4].map(i => <Icon key={i} name="star" size={34} fill={i < 4}
                sw={1.6} style={{ color: i < 4 ? 'var(--amber)' : 'var(--line-2)' }} />)}
            </div>
            <Btn full variant="primary" icon="plus">Escrever avaliação</Btn>
          </div>

          {/* list */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--gap)' }}>
            {REVIEWS.map((rv) => (
              <div key={rv.n} className="review">
                <div className="rv-head" style={{ marginBottom: 8 }}>
                  <Avatar size={40} initials={rv.i} />
                  <div style={{ flex: 1 }}>
                    <div className="rv-name">{rv.n}</div>
                    <div className="rv-date">{rv.d}</div>
                  </div>
                  <Stars value={rv.r} size={13} />
                </div>
                <p className="rv-text" style={{ margin: 0 }}>{rv.t}</p>
                <div className="divider" style={{ marginTop: 14 }} />
              </div>
            ))}
          </div>
        </div>
      </div>
    </Screen>
  );
}

Object.assign(window, { ScreenDetail, ScreenProducer, ScreenClub, ScreenReviews, REVIEWS });
