/* global React */
// ===========================================================================
// Cacau Clube — shared UI primitives (icons + components)
// Exported to window for use across screen files.
// ===========================================================================

// ---- icon set (simple rounded line icons, currentColor) ------------------
const ICONS = {
  search: 'M11 4a7 7 0 1 0 0 14 7 7 0 0 0 0-14ZM20 20l-3.5-3.5',
  heart: 'M12 20s-7-4.6-9.2-8.5C1.2 8.3 2.6 5 6 5c2 0 3 .9 4 2.2C11 5.9 12 5 14 5c3.4 0 4.8 3.3 3.2 6.5C19 15.4 12 20 12 20Z',
  bell: 'M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6M9.5 21a2.5 2.5 0 0 0 5 0',
  user: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM5 20c0-3.3 3.1-5 7-5s7 1.7 7 5',
  home: 'M4 11.5 12 4l8 7.5M6 10v9.5h12V10',
  crown: 'M4 8l3.5 3L12 5l4.5 6L20 8l-1.5 10h-13L4 8Z',
  filter: 'M4 6h16M7 12h10M10 18h4',
  sliders: 'M5 8h7M16 8h3M5 16h3M12 16h7M12 6v4M8 14v4',
  star: 'M12 3.5l2.6 5.3 5.9.9-4.2 4.1 1 5.8L12 17l-5.3 2.6 1-5.8-4.2-4.1 5.9-.9L12 3.5Z',
  chevL: 'M15 5l-7 7 7 7',
  chevR: 'M9 5l7 7-7 7',
  chevD: 'M6 9l6 6 6-6',
  share: 'M16 6l-4-4-4 4M12 2v13M5 12v7a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-7',
  pin: 'M12 21s7-5.6 7-11a7 7 0 1 0-14 0c0 5.4 7 11 7 11ZM12 12a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z',
  leaf: 'M5 19c0-9 6-14 14-14 0 9-5 14-14 14ZM5 19c2-5 5-7 9-9',
  check: 'M5 12.5l4.5 4.5L19 7',
  plus: 'M12 5v14M5 12h14',
  x: 'M6 6l12 12M18 6L6 18',
  arrowR: 'M5 12h14M13 6l6 6-6 6',
  wa: 'M12 3a9 9 0 0 0-7.7 13.6L3 21l4.5-1.2A9 9 0 1 0 12 3ZM8.5 8.2c.2-.4.4-.4.6-.4h.5c.2 0 .4 0 .6.5l.7 1.6c.1.2 0 .4 0 .5l-.4.5c-.2.2-.3.3-.1.6.2.3.8 1.3 1.7 1.8 1.1.7 1.3.5 1.6.4l.6-.7c.2-.3.4-.2.6-.1l1.5.8c.2.1.4.2.4.4 0 .4-.2 1.2-.6 1.4-.4.3-1.2.6-2.4.2a8 8 0 0 1-3.6-2.4c-1-1.2-1.6-2.5-1.7-3 0-.5.3-1.4.5-1.4Z',
  sprout: 'M12 21v-7M12 14c0-3-2-5-5-5-1 0 0 4 2 4.5 2 .5 3 .5 3 .5ZM12 14c0-4 2.5-6 6-6 1 0-.5 5-3 5.5-2 .4-3 .5-3 .5Z',
  droplet: 'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11Z',
  award: 'M12 14a5 5 0 1 0 0-10 5 5 0 0 0 0 10ZM8.5 13l-1.5 7 5-2.5 5 2.5-1.5-7',
  cup: 'M5 8h12v4a6 6 0 0 1-12 0V8ZM17 9h2a2 2 0 0 1 0 4h-2M6 3v2M9 2v3M12 3v2',
  package: 'M12 3l8 4.5v9L12 21l-8-4.5v-9L12 3ZM4 7.5l8 4.5 8-4.5M12 12v9',
  flask: 'M9 3h6M10 3v6l-5 9a1.5 1.5 0 0 0 1.3 2.3h11.4A1.5 1.5 0 0 0 19 18l-5-9V3',
  clock: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM12 7v5l3.5 2',
  google: 'GOOGLE',
  spark: 'M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8L12 3Z',
  lock: 'M7 11V8a5 5 0 0 1 10 0v3M5 11h14v9H5v-9Z',
  mail: 'M3 6h18v12H3V6ZM3 7l9 6 9-6',
  eye: 'M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12ZM12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z',
  cart: 'M0 0', // intentionally unused (no e-commerce)
};

function Icon({ name, size = 22, sw = 1.8, fill = false, style }) {
  if (name === 'google') {
    return (
      <svg width={size} height={size} viewBox="0 0 24 24" style={style}>
        <path fill="#EA4335" d="M12 10.2v3.9h5.5c-.24 1.4-1.7 4.1-5.5 4.1A6.2 6.2 0 0 1 12 5.8c1.9 0 3.2.8 3.9 1.5l2.7-2.6C16.9 3 14.7 2 12 2 6.9 2 2.8 6.1 2.8 11.2S6.9 20.4 12 20.4c5.9 0 9.8-4.1 9.8-9.9 0-.7-.1-1.2-.2-1.7H12Z"/>
      </svg>
    );
  }
  const d = ICONS[name] || '';
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill={fill ? 'currentColor' : 'none'}
      stroke={fill ? 'none' : 'currentColor'} strokeWidth={sw} strokeLinecap="round"
      strokeLinejoin="round" style={style}>
      <path d={d} />
    </svg>
  );
}

// ---- status bar ----------------------------------------------------------
function StatusBar({ time = '9:41' }) {
  return (
    <div className="statusbar">
      <span>{time}</span>
      <span className="sb-right">
        <span className="sb-bars"><i/><i/><i/><i/></span>
        <span className="sb-wifi" />
        <span className="sb-batt"><i/></span>
      </span>
    </div>
  );
}

// ---- brand mark + name ---------------------------------------------------
function Brand({ lg = false, sub = true }) {
  return (
    <div className="brand">
      <div className={'brand-mark' + (lg ? ' lg' : '')} />
      <div className="brand-name">Cacau Clube{sub && <small>Rondônia</small>}</div>
    </div>
  );
}

// ---- chips ---------------------------------------------------------------
function Chip({ label, icon, active }) {
  return (
    <span className={'chip' + (active ? ' active' : '')}>
      {icon && <Icon name={icon} size={15} sw={2} />}
      {label}
    </span>
  );
}

// ---- quality seal --------------------------------------------------------
const SEAL_META = {
  fino:   { cls: 'fino',   ic: 'award',  txt: 'Cacau Fino' },
  origem: { cls: 'origem', ic: 'pin',    txt: 'Origem RO' },
  org:    { cls: 'org',    ic: 'leaf',   txt: 'Orgânico' },
  agro:   { cls: 'agro',   ic: 'sprout', txt: 'Agrofloresta' },
  justo:  { cls: 'justo',  ic: 'check',  txt: 'Comércio Justo' },
};
function Seal({ kind }) {
  const m = SEAL_META[kind] || SEAL_META.fino;
  return (
    <span className={'seal ' + m.cls}>
      <Icon name={m.ic} size={11} sw={2.2} />{m.txt}
    </span>
  );
}

// ---- stars ---------------------------------------------------------------
function Stars({ value = 5, size = 13 }) {
  return (
    <span className="stars">
      {[0, 1, 2, 3, 4].map((i) => (
        <Icon key={i} name="star" size={size} fill={i < Math.round(value)} sw={1.6}
          style={i < Math.round(value) ? null : { color: 'var(--line-2)' }} />
      ))}
    </span>
  );
}
function Rate({ value, count }) {
  return (
    <span className="rate">
      <Icon name="star" size={13} fill style={{ color: 'var(--amber)' }} />
      {value.toFixed(1)}
      {count != null && <span className="muted">({count})</span>}
    </span>
  );
}

// ---- button --------------------------------------------------------------
function Btn({ children, variant = 'primary', full, sm, icon }) {
  return (
    <button className={`btn ${variant}${full ? ' full' : ''}${sm ? ' sm' : ''}`}>
      {icon && <Icon name={icon} size={sm ? 16 : 18} sw={2} />}
      {children}
    </button>
  );
}

// ---- placeholder image ---------------------------------------------------
function Ph({ cap, tone = '', h, style, className = '', rounded }) {
  return (
    <div className={`ph ${tone} ${className}`}
      style={{ height: h, borderRadius: rounded, ...style }}>
      {cap && <span className="ph-cap">{cap}</span>}
    </div>
  );
}

// ---- avatar placeholder --------------------------------------------------
function Avatar({ size = 46, tone = 'farm', initials }) {
  return (
    <div className="avatar" style={{ width: size, height: size }}>
      <div className={'ph ' + tone} style={{ width: '100%', height: '100%', borderRadius: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        {initials && <span style={{ fontFamily: 'Lora, serif', fontWeight: 600,
          fontSize: size * 0.34, color: 'var(--choco-800)' }}>{initials}</span>}
      </div>
    </div>
  );
}

// ---- product card --------------------------------------------------------
function ProductCard({ p }) {
  return (
    <div className="pcard">
      <div className="pcard-img">
        <Ph tone="cocoa" cap={p.cap} style={{ height: '100%', borderRadius: 0 }} />
        {p.seal && <span className="pcard-seal"><Seal kind={p.seal} /></span>}
        <span className="pcard-fav"><Icon name="heart" size={16} sw={2} /></span>
      </div>
      <div className="pcard-body">
        <span className="pcard-cat">{p.cat}</span>
        <span className="pcard-name">{p.name}</span>
        <div className="pcard-meta">
          <span className="muni"><Icon name="pin" size={13} sw={2} />{p.muni}</span>
          <Rate value={p.rating} />
        </div>
      </div>
    </div>
  );
}

// ---- bottom nav ----------------------------------------------------------
function BottomNav({ active = 'inicio' }) {
  const items = [
    { id: 'inicio', ic: 'home', label: 'Início' },
    { id: 'buscar', ic: 'search', label: 'Buscar' },
    { id: 'clube', ic: 'crown', label: 'Clube' },
    { id: 'perfil', ic: 'user', label: 'Perfil' },
  ];
  return (
    <nav className="bnav">
      {items.map((it) => (
        <div key={it.id} className={'nav-item' + (active === it.id ? ' active' : '')}>
          <span className="ni"><Icon name={it.ic} size={23} sw={active === it.id ? 2.2 : 1.8}
            fill={it.id === 'clube' && active === it.id} /></span>
          {it.label}
        </div>
      ))}
    </nav>
  );
}

// ---- timeline item -------------------------------------------------------
function TimelineItem({ icon, title, desc, when, last, done }) {
  return (
    <div className="tl-item">
      <div className="tl-rail">
        <div className={'tl-dot' + (done ? ' done' : '')}><Icon name={icon} size={15} sw={2} /></div>
        {!last && <div className="tl-line" />}
      </div>
      <div className="tl-body" style={{ paddingBottom: last ? 0 : null }}>
        <div className="tl-t">{title}</div>
        <div className="tl-d">{desc}</div>
        <div className="tl-when">{when}</div>
      </div>
    </div>
  );
}

// ---- section header ------------------------------------------------------
function SectHead({ title, action = 'Ver tudo' }) {
  return (
    <div className="sect-head">
      <h3>{title}</h3>
      {action && <a href="#">{action}</a>}
    </div>
  );
}

// ---- phone screen shell --------------------------------------------------
function Screen({ children, time, label }) {
  return (
    <div className="scr" data-screen-label={label}>
      <StatusBar time={time} />
      {children}
    </div>
  );
}

Object.assign(window, {
  Icon, StatusBar, Brand, Chip, Seal, SEAL_META, Stars, Rate, Btn, Ph, Avatar,
  ProductCard, BottomNav, TimelineItem, SectHead, Screen,
});
