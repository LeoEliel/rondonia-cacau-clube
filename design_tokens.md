# Rondônia Cacau Clube — Design Tokens

> App de vitrine + rastreabilidade de subprodutos do cacau de Rondônia.
> Tema **claro** (Material 3, custom). Paleta quente derivada do logo da marca.
> Idioma da UI: **pt-BR**.

---

## 1. Cores (hex)

### Superfícies
| Token | Hex | Uso |
|---|---|---|
| `screen-bg` | `#FBF4E9` | Fundo das telas (creme quente) |
| `surface` | `#FFFFFF` | Cards, folhas, campos |
| `surface-2` | `#FBF2E2` | Superfície sutil / alternada |
| `surface-3` | `#F4E8D4` | Trilhos, fundos de barra, chips neutros |

### Cacau (marrons)
| Token | Hex | Uso |
|---|---|---|
| `choco-950` | `#241208` | Gradiente escuro / tier premium |
| `choco-900` | `#2E1C12` | Títulos, ink principal |
| `choco-800` | `#3A2317` | Botão escuro, ícones fortes |
| `choco-700` | `#5A3522` | Texto em chips, brandmark |
| `choco-600` | `#6B3F23` | Marrom de apoio |
| `caramel`   | `#B5703A` | Selo "Comércio Justo", detalhes |

### Mel / Âmbar (destaque primário)
| Token | Hex | Uso |
|---|---|---|
| `amber` | `#D98B1F` | **Accent padrão** — CTA, chip ativo, pin |
| `amber-deep` | `#C0741A` | Texto/ícone sobre tint, links de ação |
| `amber-soft` | `#F3C95E` | Realces, kicker, estrelas claras |
| `amber-tint` | `#FBEFD2` | Fundo de selo "Cacau Fino", cartões de destaque |

### Verde-floresta (acento secundário / alternativo)
| Token | Hex | Uso |
|---|---|---|
| `green` | `#3F7A43` | Accent alternativo (Tweak), WhatsApp |
| `green-deep` | `#356637` | Texto sobre tint verde, selos orgânico/agro |
| `green-soft` | `#6BA45F` | Borda WhatsApp, realces naturais |
| `green-tint` | `#E6F0DF` | Fundo de selo "Orgânico" |

### Texto & linhas
| Token | Hex | Uso |
|---|---|---|
| `text` | `#2E1C12` | Texto primário |
| `text-2` | `#7A5D45` | Texto secundário / descrições |
| `text-3` | `#A98E72` | Texto terciário / placeholders / legendas |
| `line` | `#ECDFC8` | Bordas e divisores |
| `line-2` | `#E0CFB1` | Bordas mais visíveis / chips inativos |

### Acento (tokens semânticos — trocáveis)
> O accent aponta para **âmbar** por padrão; o Tweak "Cor de destaque" pode trocar para **verde**.

| Token | Padrão (âmbar) | Alternativo (verde) |
|---|---|---|
| `accent` | `#D98B1F` | `#3F7A43` |
| `accent-deep` | `#C0741A` | `#356637` |
| `accent-tint` | `#FBEFD2` | `#E6F0DF` |
| `accent-ink` | `#FFFFFF` | `#FFFFFF` |

---

## 2. Tipografia

**Famílias** (Google Fonts):
- **Títulos / display / histórias:** `Lora` (serif elegante humanista) — pesos 400, 500, 600, 700 + itálico.
- **Interface / corpo:** `Hanken Grotesk` (sans humanista) — pesos 400, 500, 600, 700, 800.
- **Mono (legendas técnicas/tokens):** `ui-monospace, SF Mono, Menlo, monospace`.

| Papel | Fonte | Tamanho | Peso | Line-height |
|---|---|---|---|---|
| Display | Lora | 30–34px | 600 | 1.12 |
| Título (H1 tela) | Lora | 25–27px | 600 | 1.12 |
| Título de seção | Lora | 19px | 600 | 1.2 |
| Nome de produto | Lora | 15.5–16px | 600 | 1.2 |
| História (itálico) | Lora *italic* | 15.5px | 400 | 1.55 |
| Corpo | Hanken Grotesk | 14–15px | 400 | 1.45–1.55 |
| Corpo forte | Hanken Grotesk | 14–15px | 700 | 1.45 |
| Auxiliar / meta | Hanken Grotesk | 11.5–13px | 600 | 1.4 |
| Overline / label | Hanken Grotesk | 10.5–11px | 700 | uppercase, letter-spacing 0.5px |
| Selo | Hanken Grotesk | 10.5px | 700 | letter-spacing 0.2px |

---

## 3. Espaçamento (base 4)

| Token | Valor (densidade padrão) | Uso |
|---|---|---|
| escala base | `4 · 8 · 12 · 16 · 20 · 26` | Régua de espaçamento |
| `pad` | `20px` | Padding lateral das telas |
| `gap` | `14px` | Gap entre cards / blocos |
| `gap-sm` | `9px` | Gap entre chips / itens compactos |
| `sect` | `26px` | Espaço entre seções |
| `card-pad` | `15px` | Padding interno de cards |

> **Densidade (Tweak):** multiplicador `--d` aplicado a `pad/gap/sect/card-pad`.
> `compacto = 0.82` · `padrão = 1.0` · `espaçoso = 1.16`.

---

## 4. Raio dos cantos

| Token | Valor |
|---|---|
| `r-xs` | `8px` |
| `r-sm` | `12px` |
| `r-md` | `18px` |
| `r-lg` | `26px` |
| `r-xl` | `32px` |
| `r-pill` | `999px` (pílula / circular) |

---

## 5. Elevação (sombras)

| Token | Sombra |
|---|---|
| `e-1` | `0 1px 2px rgba(46,28,18,.06), 0 1px 3px rgba(46,28,18,.05)` |
| `e-2` | `0 4px 12px rgba(46,28,18,.08), 0 2px 4px rgba(46,28,18,.05)` |
| `e-3` | `0 14px 34px rgba(46,28,18,.14), 0 4px 10px rgba(46,28,18,.07)` |

---

## 6. Selos de qualidade (mapa de cor)

| Selo | Fundo | Texto/ícone |
|---|---|---|
| Cacau Fino | `#FBEFD2` | `#C0741A` |
| Origem RO | `#F0E2CF` | `#5A3522` |
| Orgânico | `#E6F0DF` | `#356637` |
| Agrofloresta | `#E7EFE0` | `#356637` |
| Comércio Justo | `#F3E6D6` | `#B5703A` |

---

## 7. Notas para o handoff Flutter

- **ColorScheme M3:** `primary = #D98B1F` (amber), `onPrimary = #FFFFFF`, `secondary = #3F7A43` (green), `surface = #FFFFFF`, `background = #FBF4E9`, `onSurface = #2E1C12`.
- **Sem e-commerce:** nenhum token/elemento de preço, carrinho ou checkout.
- **Tipografia:** mapear `Lora` → `displayLarge/headlineLarge/titleLarge`; `Hanken Grotesk` → `bodyLarge/labelLarge`.
- **Mobile portrait** primeiro; largura de referência das telas: **390px**.
- **Hit target mínimo:** 44px (botões de ícone usam 42–44px).
