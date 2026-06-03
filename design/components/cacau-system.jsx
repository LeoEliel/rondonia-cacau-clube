/* global React, Icon, Seal, Stars, Chip, Btn, ProductCard, PRODUCTS */
// ===========================================================================
// Cacau Clube — Design System sheet (tokens + components for Flutter handoff)
// ===========================================================================

function Swatch({ name, hex, ink }) {
  return (
    <div>
      <div className="swatch" style={{ background: hex }} />
      <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--choco-900)', marginTop: 7 }}>{name}</div>
      <div className="tok">{hex}</div>
    </div>
  );
}
function DSGroup({ title, children }) {
  return (
    <div style={{ marginBottom: 32 }}>
      <div className="ds-lbl" style={{ marginBottom: 14 }}>{title}</div>
      {children}
    </div>
  );
}

function ScreenSystem() {
  return (
    <div className="ds" style={{ width: '100%' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start',
        marginBottom: 30 }}>
        <div>
          <h2>Design System</h2>
          <div style={{ fontSize: 14, color: 'var(--text-2)' }}>Rondônia Cacau Clube · tokens & componentes</div>
        </div>
        <div className="brand"><div className="brand-mark lg" /></div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: 40 }}>
        {/* left column */}
        <div>
          <DSGroup title="Cores — superfícies">
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 14 }}>
              <Swatch name="Screen" hex="#FBF4E9" />
              <Swatch name="Surface" hex="#FFFFFF" />
              <Swatch name="Surface-2" hex="#FBF2E2" />
              <Swatch name="Surface-3" hex="#F4E8D4" />
            </div>
          </DSGroup>

          <DSGroup title="Cores — cacau">
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 14 }}>
              <Swatch name="Choco 900" hex="#2E1C12" />
              <Swatch name="Choco 700" hex="#5A3522" />
              <Swatch name="Choco 600" hex="#6B3F23" />
              <Swatch name="Caramel" hex="#B5703A" />
            </div>
          </DSGroup>

          <DSGroup title="Cores — destaque & acento">
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 14 }}>
              <Swatch name="Mel (amber)" hex="#D98B1F" />
              <Swatch name="Amber soft" hex="#F3C95E" />
              <Swatch name="Verde" hex="#3F7A43" />
              <Swatch name="Verde soft" hex="#6BA45F" />
            </div>
          </DSGroup>

          <DSGroup title="Cores — texto & linhas">
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 14 }}>
              <Swatch name="Texto" hex="#2E1C12" />
              <Swatch name="Texto-2" hex="#7A5D45" />
              <Swatch name="Texto-3" hex="#A98E72" />
              <Swatch name="Linha" hex="#ECDFC8" />
            </div>
          </DSGroup>

          <DSGroup title="Tipografia">
            <div className="serif" style={{ fontSize: 34, fontWeight: 600, color: 'var(--choco-900)',
              lineHeight: 1.1 }}>Lora · Display 34</div>
            <div className="serif" style={{ fontSize: 24, fontWeight: 600, color: 'var(--choco-900)' }}>Lora · Título 24</div>
            <div className="serif" style={{ fontSize: 19, fontWeight: 600, color: 'var(--choco-900)' }}>Lora · Seção 19</div>
            <div style={{ fontSize: 15, color: 'var(--text)', marginTop: 8 }}>Hanken Grotesk · Corpo 15 / regular</div>
            <div style={{ fontSize: 15, fontWeight: 700, color: 'var(--text)' }}>Hanken Grotesk · Corpo 15 / bold</div>
            <div style={{ fontSize: 12.5, color: 'var(--text-2)' }}>Hanken Grotesk · Auxiliar 12.5</div>
            <div style={{ fontSize: 10.5, fontWeight: 700, letterSpacing: '.5px', textTransform: 'uppercase',
              color: 'var(--text-3)', marginTop: 4 }}>Hanken · Overline 10.5 · uppercase</div>
          </DSGroup>
        </div>

        {/* right column */}
        <div>
          <DSGroup title="Raio dos cantos">
            <div style={{ display: 'flex', gap: 10, alignItems: 'flex-end' }}>
              {[['sm',12],['md',18],['lg',26],['xl',32]].map(([n,r]) => (
                <div key={n} style={{ textAlign: 'center' }}>
                  <div style={{ width: 54, height: 54, background: 'var(--surface-3)',
                    border: '1px solid var(--line-2)', borderRadius: r }} />
                  <div className="tok" style={{ marginTop: 6 }}>{n} · {r}</div>
                </div>
              ))}
              <div style={{ textAlign: 'center' }}>
                <div style={{ width: 54, height: 54, background: 'var(--surface-3)',
                  border: '1px solid var(--line-2)', borderRadius: 999 }} />
                <div className="tok" style={{ marginTop: 6 }}>pill</div>
              </div>
            </div>
          </DSGroup>

          <DSGroup title="Espaçamento (base 4)">
            <div style={{ display: 'flex', gap: 10, alignItems: 'flex-end' }}>
              {[4,8,12,16,20,26].map((s) => (
                <div key={s} style={{ textAlign: 'center' }}>
                  <div style={{ width: s, height: 40, background: 'var(--accent)', borderRadius: 3,
                    margin: '0 auto' }} />
                  <div className="tok" style={{ marginTop: 6 }}>{s}</div>
                </div>
              ))}
            </div>
          </DSGroup>

          <DSGroup title="Elevação">
            <div style={{ display: 'flex', gap: 16 }}>
              {[['e-1','var(--e-1)'],['e-2','var(--e-2)'],['e-3','var(--e-3)']].map(([n,s]) => (
                <div key={n} style={{ textAlign: 'center' }}>
                  <div style={{ width: 70, height: 50, background: '#fff', borderRadius: 14,
                    boxShadow: s }} />
                  <div className="tok" style={{ marginTop: 8 }}>{n}</div>
                </div>
              ))}
            </div>
          </DSGroup>

          <DSGroup title="Botões">
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10 }}>
              <Btn variant="primary" sm>Primário</Btn>
              <Btn variant="dark" sm>Escuro</Btn>
              <Btn variant="ghost" sm>Secundário</Btn>
              <Btn variant="wa" sm icon="wa">WhatsApp</Btn>
            </div>
          </DSGroup>

          <DSGroup title="Selos de qualidade">
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              <Seal kind="fino" /><Seal kind="origem" /><Seal kind="org" />
              <Seal kind="agro" /><Seal kind="justo" />
            </div>
          </DSGroup>

          <DSGroup title="Chips / filtros">
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              <Chip label="Mel de cacau" icon="droplet" active />
              <Chip label="Nibs" icon="leaf" />
              <Chip label="Manteiga" icon="package" />
            </div>
          </DSGroup>

          <DSGroup title="Estrelas & avaliação">
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <Stars value={5} size={20} />
              <span style={{ fontFamily: 'Lora,serif', fontWeight: 700, fontSize: 18,
                color: 'var(--choco-900)' }}>4.9</span>
            </div>
          </DSGroup>

          <DSGroup title="Product card">
            <div style={{ width: 180 }}><ProductCard p={PRODUCTS[0]} /></div>
          </DSGroup>
        </div>
      </div>
    </div>
  );
}

window.ScreenSystem = ScreenSystem;
