/* global React, ReactDOM, DesignCanvas, DCSection, DCArtboard,
   useTweaks, TweaksPanel, TweakSection, TweakRadio, TweakColor,
   ScreenOnboarding, ScreenLogin, ScreenHome, ScreenSearch,
   ScreenDetail, ScreenProducer, ScreenClub, ScreenReviews, ScreenSystem */
// ===========================================================================
// Cacau Clube — canvas mount + Tweaks
// ===========================================================================

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "accent": "amber",
  "density": "padrao"
}/*EDITMODE-END*/;

const DENSITY = { compacto: 0.82, padrao: 1, espacoso: 1.16 };
const ACCENTS = {
  amber: { a: '#D98B1F', deep: '#C0741A', tint: '#FBEFD2' },
  verde: { a: '#3F7A43', deep: '#356637', tint: '#E6F0DF' },
};

const PHONE_R = 30;
const W = 390;

// phone artboards (label, component, height)
const SCREENS = [
  ['01 · Onboarding',       'ScreenOnboarding', 844],
  ['02 · Login',            'ScreenLogin',      844],
  ['03 · Home / Catálogo',  'ScreenHome',       952],
  ['04 · Busca & Filtros',  'ScreenSearch',     844],
  ['05 · Detalhe do Produto','ScreenDetail',    1520],
  ['06 · Perfil do Produtor','ScreenProducer',  1140],
  ['07 · Clube do Cacau',   'ScreenClub',       1060],
  ['08 · Avaliações',       'ScreenReviews',    900],
];

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);

  React.useEffect(() => {
    const r = document.documentElement.style;
    r.setProperty('--d', String(DENSITY[t.density] ?? 1));
    const ac = ACCENTS[t.accent] || ACCENTS.amber;
    r.setProperty('--accent', ac.a);
    r.setProperty('--accent-deep', ac.deep);
    r.setProperty('--accent-tint', ac.tint);
  }, [t.density, t.accent]);

  return (
    <React.Fragment>
      <DesignCanvas>
        <DCSection id="flow" title="Rondônia Cacau Clube"
          subtitle="Vitrine + rastreabilidade · 8 telas · pt-BR · modo claro">
          {SCREENS.map(([label, comp, h], i) => {
            const Comp = window[comp];
            return (
              <DCArtboard key={i} id={'s' + i} label={label} width={W} height={h}
                style={{ borderRadius: PHONE_R }}>
                <Comp />
              </DCArtboard>
            );
          })}
        </DCSection>

        <DCSection id="ds" title="Design System"
          subtitle="Tokens (hex), escala tipográfica, espaçamento e componentes para handoff Flutter">
          <DCArtboard id="dssheet" label="Tokens & Componentes" width={760} height={1320}
            style={{ borderRadius: 14 }}>
            <ScreenSystem />
          </DCArtboard>
        </DCSection>
      </DesignCanvas>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Densidade" />
        <TweakRadio label="Espaçamento" value={t.density}
          options={['compacto', 'padrao', 'espacoso']}
          onChange={(v) => setTweak('density', v)} />
        <TweakSection label="Cor de destaque" />
        <TweakColor label="Acento" value={t.accent === 'amber' ? '#D98B1F' : '#3F7A43'}
          options={['#D98B1F', '#3F7A43']}
          onChange={(hex) => setTweak('accent', hex === '#3F7A43' ? 'verde' : 'amber')} />
        <div style={{ fontSize: 11.5, color: '#9a8b78', padding: '4px 2px 0', lineHeight: 1.4 }}>
          Âmbar (mel) ou verde-floresta. Afeta botões, chips ativos, selos e a linha do tempo.
        </div>
      </TweaksPanel>
    </React.Fragment>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
