---
name: Devavani Divine Companion
colors:
  surface: '#fff8f6'
  surface-dim: '#e6d7d1'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1eb'
  surface-container: '#faebe4'
  surface-container-high: '#f4e5df'
  surface-container-highest: '#efdfd9'
  on-surface: '#211a16'
  on-surface-variant: '#564337'
  inverse-surface: '#372f2a'
  inverse-on-surface: '#fdeee7'
  outline: '#897365'
  outline-variant: '#dcc1b1'
  surface-tint: '#944a00'
  primary: '#944a00'
  on-primary: '#ffffff'
  primary-container: '#e67e22'
  on-primary-container: '#502600'
  inverse-primary: '#ffb783'
  secondary: '#b51a1b'
  on-secondary: '#ffffff'
  secondary-container: '#d93630'
  on-secondary-container: '#fffbff'
  tertiary: '#865300'
  on-tertiary: '#ffffff'
  tertiary-container: '#d78800'
  on-tertiary-container: '#482b00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdcc5'
  primary-fixed-dim: '#ffb783'
  on-primary-fixed: '#301400'
  on-primary-fixed-variant: '#713700'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ab'
  on-secondary-fixed: '#410002'
  on-secondary-fixed-variant: '#93000b'
  tertiary-fixed: '#ffddb9'
  tertiary-fixed-dim: '#ffb961'
  on-tertiary-fixed: '#2b1700'
  on-tertiary-fixed-variant: '#663e00'
  background: '#fff8f6'
  on-background: '#211a16'
  surface-variant: '#efdfd9'
typography:
  display-lg:
    fontFamily: Noto Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Noto Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 42px
    letterSpacing: 0em
  headline-md:
    fontFamily: Noto Sans
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 38px
    letterSpacing: 0em
  body-xl:
    fontFamily: Noto Sans
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 34px
    letterSpacing: 0.01em
  body-lg:
    fontFamily: Noto Sans
    fontSize: 20px
    fontWeight: '400'
    lineHeight: 32px
    letterSpacing: 0.01em
  body-md:
    fontFamily: Noto Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Noto Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 26px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.02em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  touch-target-min: 4rem
  pad-xs: 0.5rem
  pad-sm: 0.75rem
  pad-md: 1rem
  pad-lg: 1.5rem
  pad-xl: 2rem
  pad-2xl: 3rem
  gutter-mobile: 1.25rem
  card-gap: 1.25rem
---

## Brand & Style

This design system serves elderly devotees (ages 50+) across India and Nepal seeking a calm, reverent digital sanctuary for daily prayers, panchang, stotras, and temple darshans. The brand personality balances sacred tradition with uncompromised digital accessibility: warm, reassuring, dignified, and tactile.

Drawing from traditional temple manuscripts, sacred prayer prints (*gutka pothis*), and tactile brass prayer tools, the design movement combines **Tactile / Modern Spiritual Minimalism** with extreme high-legibility affordances. The interface rejects frenetic mobile design tropes—avoiding dense lists, minute touch targets, or low-contrast decorative text. Instead, it offers large, deliberate, and physical-feeling controls that evoke the gentle turning of sacred parchment pages and the deliberate striking of a temple bell. The emotional response is immediate ease, peace (*shanti*), visual clarity without eyestrain, and respect for spiritual routines.

## Colors

The color palette is derived directly from consecrated offerings and sanctified materials:
- **Primary (`#E67E22` - Kesariya / Marigold):** Represents devotion, dawn prayer, and spiritual warmth. Used for active navigation tabs, major primary action buttons, and focal indicators.
- **Secondary (`#B71C1C` - Kumkum / Vermilion):** Sacred red used sparingly for auspicious highlights, sacred festival dates, primary deity iconography, and alert affirmations.
- **Tertiary (`#F39C12` - Chandan / Warm Gold):** Supporting amber hue applied to borders, badge fills, and progress rings for japa mala counters.
- **Neutral & Typography (`#1F1916` & `#2C2420` - Temple Soot / Charcoal):** Deep warm dark tones ensuring an ultra-high contrast ratio (exceeding WCAG AAA standards of 7:1) against light cream backdrops for senior visual acuity.
- **Backgrounds (`#FDFBF7` & `#FAF3E0` - Handcrafted Birch / Parchment):** Soft, non-glare cream backdrops that prevent macular fatigue during extended reading of morning prayers and shlokas under direct sunlight or low indoor lighting.

## Typography

Noto Sans is implemented for both Latin and Devanagari script parity. It provides robust character rendering for complex conjuncts (*samyuktaksharas*) and vowel signs (*matras*), which degrade in condensed or decorative fonts.

Key rules for senior readability:
- **Zero Tiny Text:** No interface element drops below `16px` (`label-md`). Standard paragraph content starts at `20px` (`body-lg`) to prevent squinting.
- **Generous Leading:** Line heights are calibrated between 1.5x and 1.65x the font size, preventing matras above consonants from colliding with lower diacritics of the preceding line.
- **Enhanced Stroke Weights:** Devanagari numerals and symbols use minimum Medium (`500`) weight for core body copy to maintain stroke integrity on mid-range Android screens prevalent among older demographics.

## Layout & Spacing

The layout is built entirely around an exaggerated touch envelope and unhurried vertical flow.
- **Touch Target Floor:** All clickable elements (buttons, list entries, icons, audio controls) maintain a strict minimum bounding box of `64px` (`4rem`).
- **Single-Column Focus:** Mobile screens rely on a strict single-column layout. Two-column grids are limited to binary selection cards (e.g., "Morning Aarti" vs "Evening Aarti") to avoid visual clutter.
- **Breathing Room:** Content blocks are separated by `pad-xl` (`2rem` / 32px), visually isolating prayer verses and calendar dates to eliminate mis-taps caused by tremor or unsteady hands.
- **Reachability:** Key navigation and action zones are biased to the lower two-thirds of the viewport to accommodate one-handed thumb navigation.

## Elevation & Depth

Visual hierarchy uses warm, physical depth cues rather than synthetic digital blurs:
- **Low-Contrast Sacred Borders:** Cards and containers rest on `surface_cream` (`#FAF3E0`) and are bounded by a 1.5px soft golden rim (`#E8D8B8`). This establishes clear boundaries without harsh visual noise.
- **Sunlit Ambient Shadows:** Shadows carry an amber/soot undertone (`rgba(44, 36, 32, 0.08)`) with wide dispersion (`blur: 16px`, `y: 6px`). This makes interactive cards appear gently raised above the sacred parchment surface.
- **Tactile Pressed State:** When pressed, buttons do not flash or abruptly change color; instead, their elevation drops to zero with an inset shadow (`inset 0 3px 6px rgba(44, 36, 32, 0.15)`), mimicking physical brass switches or wooden beads.

## Shapes

In alignment with pill-shaped roundedness (`roundedness: 3`):
- **Cards and Containers:** Feature wide, welcoming radii of `24px` to `32px` (`rounded-lg` / `rounded-xl`). Sharp 90-degree corners are eliminated to evoke rolled scrolls, smooth river stones (*shaligrams*), and gentle prayer mats.
- **Buttons and Chips:** Rendered as full pills (`rounded-full`), guiding fingers naturally to the center of the touch target.
- **Dividers:** Thick, rounded decorative rules (3px height with centered sacred diamond flourishes) demarcate reading chapters.

## Components

### Buttons
- **Primary Devotional Button:** Pill-shaped, minimum height of `64px`, filled with Kesariya (`#E67E22`), containing bold 20px white text alongside an oversized icon (32px).
- **Secondary / Audio Button:** Surface cream fill (`#FAF3E0`), 2px border in `#E8D8B8`, dark charcoal text (`#1F1916`). Designed specifically for audio playback controls (*Suno / Pause*).

### Prayer Verses & Shloka Cards
- Elevated parchment cards with `pad-lg` (24px) internal padding.
- Hindi text displayed in 22px (`body-xl`) with 36px line height.
- Includes a dedicated "Font Zoom" button pinned within easy reach on every scripture card.

### Lists & Panchang Items
- List rows maintain an 80px minimum vertical height.
- Separated by 12px vertical gaps (not single hair lines) so each tithi, nakshatra, or festival row functions as an independent, tap-friendly capsule.

### Forms, Checkboxes & Toggles
- Checkboxes and radio targets measure 36x36px within a 64px tap area.
- Toggles feature a heavy thumb (32px) and warm amber fill for high visibility confirmation of active alarms for Brahma Muhurta.

### Specialized Component: Japa Mala Counter
- A circular, high-tactile central button (diameter: `120px`) with haptic pulse integration on every touch.
- Number display in bold `36px` Devanagari numerals that increments smoothly with each chant completion up to 108.