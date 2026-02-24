# HUE — Kapsamlı Ürün, Tasarım ve Teknik Spesifikasyon
**claude.md** | Version: 2.0 | Model: Presence → Intent → Conversation

> Bu belge Hue'nun tek gerçek kaynağıdır (single source of truth). Tasarım kararları, geliştirme öncelikleri, UX kuralları ve kabul kriterleri buradan türetilir. Burada tanımlı olmayan hiçbir özellik sahaya çıkmaz.

---

## İÇİNDEKİLER

1. [Ürün Felsefesi & Kimliği](#1-ürün-felsefesi--kimliği)
2. [Temel İletişim Katmanları](#2-temel-i̇letişim-katmanları)
3. [Global Tasarım Dili](#3-global-tasarım-dili)
4. [Navigasyon Haritası](#4-navigasyon-haritası)
5. [Giriş & Kayıt Politikası](#5-giriş--kayıt-politikası)
6. [Splash Screen](#6-splash-screen)
7. [Onboarding Akışı](#7-onboarding-akışı)
8. [Home — Presence Board](#8-home--presence-board)
9. [Intent Panel](#9-intent-panel)
10. [Photo + Hue Akışı](#10-photo--hue-akışı)
11. [Conversation Modu](#11-conversation-modu)
12. [Contact Profile Modal](#12-contact-profile-modal)
13. [Settings & Hesap](#13-settings--hesap)
14. [İzin Akışları](#14-i̇zin-akışları)
15. [Bildirim Sistemi](#15-bildirim-sistemi)
16. [Hata Durumları & Edge Case'ler](#16-hata-durumları--edge-caseler)
17. [Boş Durum Tasarımı](#17-boş-durum-tasarımı)
18. [Erişilebilirlik](#18-erişilebilirlik)
19. [Animasyon & Motion Kuralları](#19-animasyon--motion-kuralları)
20. [Mikrokopi Rehberi](#20-mikrokopi-rehberi)
21. [Analytics & Başarı Metrikleri](#21-analytics--başarı-metrikleri)
22. [Psikolojik Tasarım İlkeleri](#22-psikolojik-tasarım-i̇lkeleri)
23. [Figma Deliverable Listesi](#23-figma-deliverable-listesi)
24. [Teknik Mimari Notları](#24-teknik-mimari-notları)
25. [Kabul Testi Checklist](#25-kabul-testi-checklist)
26. [Sonraki Adımlar & Yol Haritası](#26-sonraki-adımlar--yol-haritası)

---

## 1. Ürün Felsefesi & Kimliği

### 1.1 Ne DEĞİLdir Hue

Hue bir mesajlaşma uygulaması DEĞİLDİR.
Hue WhatsApp'ın daha hızlı versiyonu DEĞİLDİR.
Hue bir chat UI klonu DEĞİLDİR.

### 1.2 Hue Nedir

Hue; insanların konuşmadan önce birbirini anlamasını sağlayan, **varlık temelli** (presence-based) bir iletişim katmanıdır.

Temel iş tanımı:
> **Gereksiz konuşmaları ortadan kaldırmak.**

Hue, iki insan birbirine yazmadan anlayabildiğinde başarılıdır.
Hue, kullanıcılar normal sohbet etmeye başladığında başarısızdır.

### 1.3 İnsan İletişiminin Doğal Sırası

Gerçek hayatta insanlar şu sırayı izler:

```
Fark etme (Presence) → Sinyal verme (Intent) → Konuşma (Conversation)
```

Modern mesajlaşma uygulamaları 1. ve 2. adımları atlayıp doğrudan 3. adımdan başlar.
Bu; kaygı, sosyal baskı ve yorgunluk yaratır.

Hue bu sırayı yeniden inşa eder.

### 1.4 Ürün Kimlik Cümlesi

> "Hue; insanların konuşmaya ihtiyaç duymadan önce birbirini anlamasına olanak tanıyan, varlık temelli bir iletişim katmanıdır."

### 1.5 Ne Zaman Başarılı Sayılırız

- Kullanıcı günde birden fazla intent gönderiyorsa ✓
- Kullanıcı sık sık acknowledge ediyorsa ✓
- Kullanıcı conversation modunu nadiren açıyorsa ✓
- Kullanıcı uygulamayı sadece durumları görmek için açıyorsa ✓

### 1.6 Ne Zaman Başarısız Sayılırız

- Kullanıcılar klavyeye doğrudan atlıyorsa ✗
- Intent katmanı görmezden geliniyorsa ✗
- Uygulama başka bir chat klonu gibi kullanılıyorsa ✗
- Conversation modu varsayılan ortam gibi hissettiriyorsa ✗

---

## 2. Temel İletişim Katmanları

### 2.1 Katman 1: Presence (Varlık)

**Anlam:** "Bu kişi şu an gerçekte müsait mi?"

Presence şunların yerini alır:
- Online göstergesi
- Son görülme zamanı
- "Yazıyor..." kaygısı

**Presence Kuralları:**
- Pasiftir, her zaman görünürdür, hiçbir zaman gürültülü değildir
- Etkileşim gerektirmeden okunabilir olmalıdır
- Nadiren ve sakin şekilde değişir
- Asla yanıp sönme, sık güncelleme veya kaygı tetikleyici gösterge içermez

**Presence Yanıtladığı Soru:**
> "Bu kişiyle şu an iletişim kurmalı mıyım?"

**Presence Durumları:**

| Durum | Renk Aurası | Anlam |
|---|---|---|
| Müsait | Sıcak amber | Konuşmaya açık |
| Dinleme modu | Soft mavi | Sakin, pasif |
| Derin sohbet | Menekşe | Yalnızca derin konuşma |
| Meşgul | Nötr gri | Şu an uygun değil |
| Uyuyor | Koyu gri | Rahatsız etme |
| Yolda | Yeşilimsi | Kısa sürede müsait |

### 2.2 Katman 2: Intent (Niyet)

**Anlam:** "Sohbet başlatmadan bir şey iletmek istiyorum."

Intent şunların yerini alır:
- "geliyorum"
- "müsait misin?"
- "sonra konuşalım"
- "uyuyorum"
- "gördüm"
- "kırgınım ama kavga değil"
- "konuşamam ama önemli değil"
- "ok", "tm", "👍", "gördüm"

**Intent'in Kalbi:**
Intent, ürünün kalbidir. En hızlı etkileşim intent göndermek olmalıdır.
Intent göndermek yazmaktan daha yavaşsa → ürün başarısız demektir.

**Intent Karakteristikleri:**
- Geçici anlam taşır (ephemeral)
- Düşük bilişsel yük
- Hızlı gönderilir
- Hızlı onaylanır (acknowledge)

**Intent Kategorileri (Presets):**

| Kategori | Gradient | Kullanım |
|---|---|---|
| Sadece kontrol | Soft turuncu | "Nasılsın" anlamında |
| Yardım lazım | Sıcak kırmızı | Acil olmayan yardım talebi |
| Bir şey paylaşmak istiyorum | Sarı/altın | Haber, düşünce |
| Derin sohbet | Menekşe/lacivert | Ciddi konu |
| Pratik soru | Açık mavi | Hızlı bilgi |
| Serbest | Nötr gri | Konuşmak istiyorum ama nedenini bilmiyorum |
| Meşgulum | Koyu kırmızı | Şu an kesmeyeceksin |
| Uyuyorum | Lacivert | Gece modu |
| Yoldayım | Yeşil | Geliyorum |

### 2.3 Katman 3: Conversation (Sohbet)

**Anlam:** Intent yetersiz kaldığında girilen kasıtlı alan.

**Conversation Kuralları:**
- İzin verilmiş ama teşvik edilmemiştir
- Yalnızca intent yetersiz kaldığında var olur
- Farklı bir moda girme hissi yaratmalıdır — varsayılan ortam değil
- Görsel olarak ikincildir
- Kullanıcı eylemini gerektirir ("Sohbet aç" butonu)
- Doğal ve her zaman erişilebilir hissettirirse → kullanıcılar intent katmanını terk eder

---

## 3. Global Tasarım Dili

### 3.1 Görsel Ton

- Sakin, sıcak, kurumsal olmayan
- Keskin kontrastlardan kaçınılır
- Telegram stiker gibi oyunbaz değil
- iMessage gibi steril değil
- Duygusal ama minimal

### 3.2 Izgara & Spacing

```
Grid base:         8pt
Outer padding:     24pt
Card padding:      16pt (horizontal), 12pt (vertical)
Section spacing:   32pt
Icon size (small): 20px
Icon size (medium):28px
```

### 3.3 Dokunma Hedefleri

```
Primary touch (Hue Button):   72px diameter
Standard minimum touch:       44px
Preference minimum:           48px
```

### 3.4 Corner Radii

```
Cards:       20pt
Modals:      28pt
Buttons:     14pt (pill: 999pt)
Images:      16pt
Presets:     Full circle (24px radius)
```

### 3.5 Renk Sistemi

```
Arkaplan (Primary):    #0F1724
Arkaplan (Secondary):  #141D2B
Kart yüzeyi:           #1A2234
Metin (primary):       #E8ECF4
Metin (secondary):     #7A8399
Metin (disabled):      #3D4A60
Border (subtle):       #1F2D42
```

Hue öğeleri ışık yayıcı (glow) efektiyle gösterilir.
Renk değerleri dinamiktir; her intent kategori için ayrı gradient tanımlanır.

**Gradient Örnekleri:**

```
Sıcak / Müsait:    #FF8C42 → #FFB347
Meşgul:            #C0392B → #922B21
Derin sohbet:      #6C3483 → #1A5276
Dinleme:           #2471A3 → #85C1E9
Yolda:             #1E8449 → #52BE80
Uyuyor:            #1C2833 → #2C3E50
```

### 3.6 Tipografi

```
Font ailesi:         System font (SF Pro — iOS, Roboto — Android)
Title:               20pt, semibold
Subtitle:            17pt, medium
Label:               15pt, medium
Body:                15pt, regular
Meta / Zaman:        13pt, regular
Caption:             11pt, regular
```

**Tipografi İlkesi:** Okunabilirlik > Stil. Hiyerarşi bir mektup okuma hissi yaratır, bir dashboard değil.

### 3.7 İkon Sistemi

- Tüm ikonlar SVG, 24x24 base boyut
- Stroke tabanlı (fill değil)
- Köşeler yumuşatılmış
- Sistem ikonlarıyla uyumlu (SF Symbols — iOS)
- Her ikona semantic label zorunlu

---

## 4. Navigasyon Haritası

```
Splash
  └─→ Onboarding A (Problem)
        └─→ Onboarding B (Keşif)
              └─→ Onboarding C (İnteraktif Demo)
                    └─→ Presence Board (Home)
                          ├─→ [Kart tap] Intent Panel (Bottom Sheet)
                          │     ├─→ [Send] → Intent Gönderildi (toast + dismiss)
                          │     ├─→ [Foto] → Kamera/Galeri → Hue Zorunluluğu → Send
                          │     └─→ [Sohbet aç] → Conversation Screen
                          │                          └─→ [Exit/Back] → Presence Board
                          ├─→ [Avatar tap] → Contact Profile Modal
                          ├─→ [Long press kart] → Quick Actions
                          └─→ [Hamburger/Ayarlar] → Settings Screen
```

---

## 5. Giriş & Kayıt Politikası

### 5.1 Felsefe

Kullanıcı "kayıt olmaz" — **erişilebilir hale gelir.**

Kayıt formu yoktur. Login duvarı yoktur.
Felsefe önce deneyimlenir, sonra sürtünme yaşanır.

### 5.2 V1 Kimlik Mekanizması

- **Device ID + Display Name** prompt (local cache)
- Şifre yok
- E-posta yok
- Telefon doğrulaması yok (sonraki sürüm)

### 5.3 Gerekli Alanlar (Minimal Setup)

| Alan | Zorunlu | Açıklama |
|---|---|---|
| Display name | Evet | 2–30 karakter |
| Avatar | Hayır | Atlanabilir, sonradan eklenebilir |
| E-posta | Hayır | Sonraki sürüm |
| Telefon | Hayır | Sonraki sürüm |

### 5.4 Gizlilik Varsayılanları

- EXIF konum bilgisi varsayılan olarak strip edilir
- Analytics varsayılan açık (iç testler için), kullanıcı kapatabilir
- Kamera ve push izinleri onboarding sırasında istenir, açılışta değil

---

## 6. Splash Screen

### 6.1 Amaç

1.5 saniyede marka hissi vermek. Hiçbir etkileşim gerektirmez.

### 6.2 İçerik

```
[Orta] Logo (rounded square + imza ikon)
[Alt]  "Mesaj değil, niyet gönder."
```

### 6.3 Animasyon

- Logo: opacity 0 → 1, scale 0.92 → 1.0, 600ms easeOut
- Metin: opacity 0 → 1, delay 400ms, 400ms easeOut

### 6.4 Geçiş

```
İlk açılış:    1600ms → Onboarding A
Dönen kullanıcı: 1200ms → Presence Board
```

### 6.5 Kabul Kriterleri

- [ ] Hiçbir buton bulunmaz
- [ ] Auto geçiş 1200–1800ms aralığında gerçekleşir
- [ ] Hiçbir network çağrısı yapılmaz
- [ ] Logo dosyası 1024px PNG + SVG adaptive

---

## 7. Onboarding Akışı

### 7.1 Felsefe

Okuma değil **yapma** ile öğretmek.
3 ekran, sıralı, zorunlu (V1'de skip yok).

---

### 7.2 Onboarding A — Problem Ekranı

**Amaç:** Mevcut mesajlaşma kaygısını yüzeyine çıkarmak.

**Layout:**
```
[Üst alan — %40]    Boşluk / nefes
[Orta]              Animasyon (typing loop)
[Alt]               "Bazen yazmak fazla gelir."
                    [Devam] butonu
```

**Animasyon:**
- 3 satırlı typing → delete loop
- 800ms / döngü
- easeInOut
- Mesajlar: "Tamam", "Peki", "Görüyorum" → siler → tekrar yazar

**Kabul Kriterleri:**
- [ ] Kullanıcı devam etmeden animasyon en az 1 tam döngü gösterilir
- [ ] Buton tap'i sayfalandırır, form yoktur

---

### 7.3 Onboarding B — Keşif Ekranı

**Amaç:** Hue konseptini duygusal olarak tanıtmak.

**Layout:**
```
[Orta]    Büyük nefes alan Hue orb animasyonu
[Alt]     "Bir renk seç. Yeter."
          [Devam] butonu
```

**Animasyon:**
- Orb: scale 0.96 → 1.04 → 0.96
- Duration: 1200ms
- easeInOutSine
- Glow efekti: opacity 0.4 → 0.8 → 0.4 sync

**Kabul Kriterleri:**
- [ ] Orb rengi her açılışta farklı preset'ten başlar
- [ ] Animasyon yeterince yavaş ve sakin hissettirir

---

### 7.4 Onboarding C — İnteraktif Demo (Kritik)

**Amaç:** Kullanıcının gerçek bir Hue gönderip acknowledge almasını sağlamak.

**Layout:**
```
[Üst]    Sahte mini-conversation UI
         - "Ayşe" adlı kişi görünür
         - Presence durumu: "müsait"
[Orta]   Büyük Hue Button
[Alt]    "Başla" butonu — DEVRE DIŞI (demo tamamlanana kadar)
```

**Interaction Akışı:**
1. Kullanıcı Hue Button'a tap eder
2. Preset panel açılır (3 preset gösterilir)
3. Kullanıcı preset seçer
4. Send animasyonu oynar
5. Mock "Ayşe" tarafında acknowledge gösterilir (0.8s sonra)
6. "Başla" butonu aktif olur

**Kilitli Durum:**
- "Başla" butonu: opacity 0.4, tap disabled
- Tooltip (opsiyonel): "Önce bir hue gönder"

**2 Dakika Timeout:**
- Kullanıcı 2 dakika demo yapmadıysa küçük pulse animasyonu Hue Button'da tekrar başlar
- V1: Skip yok

**Kabul Kriterleri:**
- [ ] Kullanıcı demo tamamlamadan "Başla" aktif olmaz
- [ ] Mock acknowledge gerçekçi animasyona sahip
- [ ] Tüm akış klavye olmadan tamamlanır

---

## 8. Home — Presence Board

### 8.1 Felsefe

Bu ekran chat listesi değil, **insanları gösteren yaşayan bir panel**dir.

Mental model: "People Panel" (Kişiler Paneli)
Yanlış mental model: "Sohbet listesi"

Kullanıcı, konuşmak için değil, insanları görmek için Hue'yu açabilmelidir.

### 8.2 Layout

```
[Top Bar]
  Sol:    Hamburger menü / Ayarlar kısayolu
  Orta:   "Hue" logosu (küçük)
  Sağ:    Arama ikonu

[Arama Alanı] (ikon tap'i ile açılır)
  Input: isim filtre
  Placeholder: "Kişi ara"

[Liste: Dikey kartlar, auto-layout]
  Her kart:
    [Avatar]      56x56px, daire, presence aura
    [İsim]        Label 15pt semibold
    [Presence]    Dot + kısa label
    [Son Intent]  Gradient swatch 30x12px + saat
    [Saat]        Meta 13pt, sağ hizalı
```

### 8.3 Kart Spesifikasyonu

```
Kart yüksekliği:       78pt
Yatay padding:         16pt
Avatar boyutu:         56x56px
Avatar margin-right:   12pt
Presence dot:          8px diameter
Dot margin-right:      4pt
Son intent swatch:     30x12px, corner radius 4pt
```

**Gösterilmeyenler:**
- Son mesaj metni preview'u → YASAK
- Okunmamış mesaj sayacı → YASAK
- "Son görülme: X saat önce" → YASAK

**Gösterilenler:**
- Son intent renk swatchi
- Son intent saati ("3s önce", "2sa önce")
- Presence durumu

### 8.4 Davranışlar

| Etkileşim | Sonuç |
|---|---|
| Kart tap | Intent Panel açılır (150–260ms) |
| Avatar tap | Contact Profile Modal açılır |
| Long press kart | Quick Actions menüsü |
| Arama ikonu tap | Arama input açılır |

### 8.5 Quick Actions (Long Press)

```
[Sessiz / Unmute]
[Kişiyi Engelle]
[Profili Gör]
```

Ağır aksiyonlar (delete conversation vb.) burada yoktur.
Confirm dialog: Engelleme için zorunlu.

### 8.6 Sıralama Mantığı

Default sıralama:
1. En son intent gönderilen / alınan
2. Presence durumu (müsait önce gelir)
3. Alfabetik (eşitlik durumunda)

### 8.7 Kabul Kriterleri

- [ ] İlk açılışta klavye görünmez
- [ ] Her kartta son intent görseli var, text preview yok
- [ ] Kart tap → Intent Panel 200ms içinde açılır
- [ ] Presence durumu metin label gerektirmeden renkten anlaşılır

---

## 9. Intent Panel

### 9.1 Felsefe

Hue gönderimini maksimum hızda yapma: 3 tap veya daha az.
UI her zaman bu aksiyona doğru yönelir.

Açılışta:
- Klavye YOK
- Metin önerisi YOK
- Composer YOK

### 9.2 Layout

```
[Bottom Sheet — Yükseklik: %52 ekran (adaptive)]

[Başlık]
  Sol:   Avatar (32px) + Kişi adı (Label semibold)
  Sağ:   "Sohbet aç" butonu (secondary, outline)

[Preview Orb — Merkez üst]
  Boyut: 96px diameter
  Canlı renk değişimi (seçime göre)
  Glow efekti

[Presets Row]
  5 adet circular preset (48px)
  Her preset'in altında label (11pt, 2 satır max)
  Horizontal scroll (6+)

[Custom Slider] (opsiyonel)
  Intensity 0–100
  "Yoğunluk" label

[Alt Bar]
  Sol:   Fotoğraf ikonu (kamera/galeri)
  Sağ:   Send Butonu (72px circle, primary)
          — disabled: hue seçilmemişse
          — disabled: foto var ama hue yoksa
```

### 9.3 Preset Tanımları

| # | Label | Gradient | Kullanım |
|---|---|---|---|
| 1 | Sıcak | #FF8C42 → #FFB347 | Genel müsaitlik |
| 2 | Meşgul | #C0392B → #922B21 | Şu an uygun değil |
| 3 | Dinle | #2471A3 → #1A5276 | Sakin mod |
| 4 | Geliyor | #1E8449 → #145A32 | Yolda |
| 5 | Derin | #6C3483 → #4A235A | Ciddi konu |
| + | Özel | — | Slider ile |

### 9.4 Interaction Map

```
Preset tap         → Preview orb güncellenir, Send aktif
Send tap           → Orb animasyonu (shrink & fly) → Sheet dismiss → Toast
Foto ikonu tap     → Kamera/galeri açılır → Seçim sonrası Hue zorunlu
"Sohbet aç" tap    → Conversation screen (stack push)
Long press Send    → "Sohbet aç" seçeneği gösterilir (V1)
Sheet dismiss      → Aşağı swipe veya dışarı tap
```

### 9.5 Send Animasyonu

1. Orb: scale 1.0 → 0.85 (80ms)
2. Orb: translate yukarı → ekran dışı (160ms)
3. Sheet: dismiss (180ms)
4. Toast: fade in (200ms)

Toplam algılanan süre: < 400ms

### 9.6 Undo Toast

```
Metin:      "Gönderildi — geri al"
Süre:       3 saniye görünür
Tap:        Intent iptal edilir
Auto-hide:  3s sonra fade out
Konum:      Ekran alt kısmı, floating
```

### 9.7 Accessibility

- Her preset: accessible label (ör: "Sıcak tonu, yoğunluk 80%")
- Send butonu: "Gönder [kişi adına] sıcak hue"
- Foto butonu: "Fotoğraf ekle"

### 9.8 Kabul Kriterleri

- [ ] Send disabled — hue seçilmemişse
- [ ] Send disabled — foto var ama hue seçilmemişse
- [ ] Foto flow hue seçimini otomatik açar
- [ ] Send animasyonu 400ms algılanan süreden kısa
- [ ] Undo toast 3s sonra kaybolur

---

## 10. Photo + Hue Akışı

### 10.1 Felsefe

Fotoğraflar bağlamsal sinyaldir, içerik değil.

```
Fotoğraf tek başına → bilgi
Fotoğraf + Intent   → anlam
```

**Masa fotoğrafı + meşgul → arama**
**Sokak fotoğrafı + geliyor → bekle**

Bu nedenle: Fotoğraf, hue olmadan gönderilemez.
Aksi halde uygulama medya chat'e döner.

### 10.2 Akış Adımları

```
1. Kullanıcı Intent Panel'de foto ikonuna tap eder
   (veya Hue Button'a double tap → hızlı kamera)

2. Sistem kamera/galeri açılır
   (izin gerekiyorsa izin modali)

3. Kullanıcı fotoğraf çeker veya seçer

4. Intent Panel'e döner:
   - Görsel preview: 160x160px, rounded 16pt
   - Hue seçimi zorunlu, send hâlâ disabled

5. Kullanıcı hue seçer → Send aktif

6. Send:
   - Client-side: WebP dönüşüm, ~%75 kalite
   - Upload: presigned URL
   - Metadata: photo_url + hue_id + intensity + timestamp
   - Toast + undo 3s
```

### 10.3 Görsel İşleme Kuralları

```
Thumbnail:  400x400 (liste için)
Preview:    1200x1200 (tam görünüm)
Original:   Opsiyonel saklama
Format:     WebP (fallback: JPEG)
EXIF:       Konum varsayılan strip
            Kullanıcı açarsa → küçük konum ikonu gösterilir
```

### 10.4 Hata Durumları

- Upload başarısız → retry toast
- İzin reddedilmiş → Settings'e yönlendiren inline toaster
- Dosya çok büyük (>20MB) → "Dosya çok büyük, farklı fotoğraf seç"

### 10.5 Tooltip (Hue Seçilmemişse)

```
"Renk seçmeden gönderemezsin."
```

Konum: Send butonunun üstünde, ok ile işaret eden
Süre: 2s görünür veya tap'e kadar

### 10.6 Kabul Kriterleri

- [ ] Fotoğraf seçimi her zaman hue seçimini tetikler
- [ ] Hue olmadan send imkânsız
- [ ] Tooltip açıklayıcı, yargılamayan
- [ ] Upload hatası retry imkânı verir

---

## 11. Conversation Modu

### 11.1 Felsefe

Conversation kasıtlı bir yükselmedir (deliberate escalation).

Girişi açık bir kapı gibi hissettirir.
Çıkışı intent dünyasına döndürür.
Conversation, uygulamayı görsel olarak asla domine edemez.

### 11.2 Giriş Yolları

```
Intent Panel → "Sohbet aç" butonu → Conversation Screen (stack push)
Long press Send → seçenek menüsünden "Sohbet başlat"
```

Otomatik açılma: YOKTUR.
Conversation her zaman kullanıcı eylemi gerektirir.

### 11.3 Layout

```
[Header]
  Sol:   ← Geri (Presence Board'a döner)
  Orta:  Kişi adı (Title)
         Alt: Intent label (ör: "Derin sohbet • İkisi de hazır")
  Sağ:   "Presence'a dön" butonu

[Mesaj Alanı]
  Arkaplan: #0F1724 (aynı)
  Bubble'lar: düşük kontrastlı, nötr (#1F2A36)

[Hue Mesajları]
  Sol/sağ hizalı circular swatch (büyük)
  Foto thumbnail varsa: swatch üstünde görünür
  Görsel olarak primary

[Metin Mesajları]
  Küçük pill bubble
  Düşük kontrast (#1F2A36)
  Yüksek opaklıkta değil
  Hue mesajlarından görsel olarak ikincil

[Alt Bar]
  Default: "Yazı yaz" butonu (sadece tap açar, persistent değil)
  Hue gönder: small orb shortcut (sağ köşe)
```

### 11.4 Mesaj Composer

- Varsayılan: Gizli (persistent bar yok)
- "Yazı yaz" tap'i veya long press → Composer modal (top overlay)
- Composer modal: küçük input, max 280 karakter, send butonu
- Klavye kapandığında composer da kapanır
- Tüm metin mesajları `type: "text"` metadata ile flaglenir

### 11.5 Mesaj Görsel Hiyerarşisi

```
1. Hue (renkli orb)         ← En belirgin
2. Foto + Hue               ← İkinci en belirgin
3. Acknowledge işaretleri   ← Soft, dikkat çekmiyor
4. Metin mesajları          ← En alt görsel önem
5. Zaman damgaları          ← Düşük opaklık, küçük
```

### 11.6 Acknowledge Sistemi

Her intent bir acknowledge bekler.

Acknowledge iletiyi verir:
> "Durumunu anladım"

Vermediği şey:
> "Mesajını okudum"

Görsel davranış:
- Soft çift nokta → acknowledge bekleniyor
- Soft onay ikonu → acknowledge alındı
- Red receipts: YOK (sosyal baskı oluşturur)

### 11.7 V1 Kısıtlamaları

```
Yanıt/Thread:       YOK
Emoji reaksiyonu:   YOK
Mesaj silme:        YOK (undo 3s var)
Sesli mesaj:        YOK
Grup sohbet:        YOK
```

### 11.8 Kabul Kriterleri

- [ ] Conversation'a giriş her zaman kasıtlı kullanıcı eylemi gerektirir
- [ ] Metin mesajları görsel olarak hue mesajlarından ikincil
- [ ] Conversation'dan çıkış Presence Board'a döner, kayıt olmaz
- [ ] Composer default gizli, modal olarak açılır

---

## 12. Contact Profile Modal

### 12.1 Amaç

Kişinin güncel durumunu ve son intentlerini hızlı görmek.

### 12.2 Layout

```
[Modal — orta ekran, card, 28pt radius]

[Avatar]        80px diameter
[İsim]          Title 20pt semibold
[Presence]      Dot + label + "1 saat önce hue attı"

[Son İntentler]  Son 5 intent (swatch + saat, horizontal scroll)

[Aksiyonlar]
  [Intent Gönder]     Primary
  [Sohbet Aç]         Secondary
  [Sessize Al]        Tertiary
```

### 12.3 Notlar

- Live presence yerine relative zaman ("1 saat önce aktifti") gösterilir
- Real-time tracking kaygı yaratır

### 12.4 Kabul Kriterleri

- [ ] Modal açılması 200ms içinde
- [ ] Dışarı tap veya swipe ile kapanır
- [ ] Hiçbir şekilde "şu an yazıyor" gösterilmez

---

## 13. Settings & Hesap

### 13.1 Felsefe

Settings; kontrol ve gizlilik için var. Konfigürasyon paneli gibi hissettirmez.
Her seçenek açıklayıcı mikrokopi ile desteklenir.

### 13.2 Bölümler

**Hesap**
```
- Display name düzenle
- Avatar düzenle/değiştir
- Hesabı sil (soft delete + confirmation)
- Çıkış yap
```

**Bildirimler**
```
- Push bildirimleri (açık/kapalı)
- Preview stili: hue rengi göster / gizle
```

**Fotoğraflar**
```
- Cihaza kaydet (açık/kapalı)
- EXIF konum dahil et (varsayılan: kapalı)
```

**Davranış**
```
- Conversation'da metin composer varsayılan göster (varsayılan: kapalı)
  Mikrokopi: "Bu güç kullanıcı seçeneğidir. Kapalı önerilir."
- Presence güncellemelerini otomatik paylaş (açık/kapalı)
```

**Hakkında & Gizlilik**
```
- Gizlilik politikası
- İletişim
- Sürüm numarası
```

**Analytics (iç testler)**
```
- Anonim kullanım verisi paylaş (varsayılan: açık)
  Mikrokopi: "Hue'yu geliştirmemize yardım eder. Hiçbir kişisel veri paylaşılmaz."
```

### 13.3 Veri Silme

Hesap silindiğinde:
- Server-side deletion (varsa)
- Local cache temizlenir
- Confirmation: "Tüm verin silinecek. Geri alınamaz."

### 13.4 Kabul Kriterleri

- [ ] Settings Home top-left veya hamburger'dan erişilebilir
- [ ] Gizlilik toggle'ları açıkça anlatılmış
- [ ] Hesap silme iki adım onay gerektirir

---

## 14. İzin Akışları

### 14.1 Push Bildirimleri

**Ne zaman:** Onboarding C sonrasında, Home ilk açılışında

**Rationale Modal:**
```
Başlık:  "Anlık Hue'lar için bildirim izni"
Metin:   "Hue bildirimleri için izin ver. Sessiz bildirimler de desteklenir."
Buton 1: "İzin Ver" (primary)
Buton 2: "Şimdi Değil" (secondary, UX uyarısı gösterir)
```

**Skip Uyarısı:**
```
"Bildirimleri kapatırsan Hue'ları gecikmeli alırsın."
```

### 14.2 Kamera & Fotoğraflar

**Ne zaman:** Kullanıcı foto ikonuna tap ettiğinde (just-in-time)

**Rationale:**
```
"Fotoğraf çekmek için izin ver. Fotoğraflar EXIF'ten konum kaldırılır."
```

### 14.3 Mikrofon

V1'de istenmez. Sesli mesaj yok.

### 14.4 İzin Reddedilmişse

```
[Inline Toaster]
"Kamera erişimi kapalı. Ayarlar'dan aç."
[Ayarlar'a Git] buton
```

---

## 15. Bildirim Sistemi

### 15.1 Bildirim Tipleri

| Tip | İçerik | Aksiyonlar |
|---|---|---|
| Intent alındı | "[İsim] bir hue gönderdi" | Ack yap / Aç |
| Ack alındı | "[İsim] hue'nu gördü" | Sessiz (badge yok) |
| Sohbet mesajı | "[İsim] yazdı" | Aç |

### 15.2 Bildirim Kuralları

```
Kırmızı badge: YOK
"Son görülme" ifadesi: YOK
Urgent / alarming ton: YOK
```

Bildirimler:
- Bilgilendirici, baskı kurmayan
- Sosyal kaygı yaratmayan içerik

### 15.3 Quiet Hours

Kullanıcı "sessiz saatler" tanımlayabilir.
Bu saatlerde intent alınır ama bildirim çalmaz.
Bildirim: sabah kümeli özet (opsiyonel).

---

## 16. Hata Durumları & Edge Case'ler

### 16.1 Ağ Hataları

```
Upload başarısız:
  Toast: "Gönderilemedi — Tekrar Dene" + "İptal"
  İptal → Undo mantığı

Çevrimdışı:
  Banner: "İnternet bağlantısı yok"
  Kuyruk: Intent'ler local queue'ya eklenir
  Online olunca: otomatik retry
  Kullanıcıya gösterilir: "1 intent gönderilmeyi bekliyor"
```

### 16.2 Kamera İzin Sorunları

```
Mid-flow izin iptali:
  "Kamera erişimi kapatıldı. Ayarlar > Hue > Kamera'yı aç."
  [Ayarlar'a Git]
```

### 16.3 Push Token Hatası

```
Settings badge gösterilir
Metin: "Bildirimleri etkinleştir"
Hatırlatıcı bir kez gösterilir, ısrarcı değil
```

### 16.4 Kayıtlı Olmayan Kişi

```
"[İsim] henüz Hue'da değil"
[Davet Et] → Share sheet (SMS / WhatsApp)
```

### 16.5 Boş Kişi Listesi

Ayrı bölümde ele alınmıştır (17. Bölüm).

---

## 17. Boş Durum Tasarımı

### 17.1 Felsefe

Boş ekranlar bozuk hissettirmez.
Her şey sosyal çerçevede ifade edilir, teknik değil.

### 17.2 Boş Durumlar

**Kişi yok (Home):**
```
Metin: "Konuşmalar biri erişilebilir hale gelince başlar."
CTA:   "Arkadaşını Davet Et"
Alt:   "Ama önce demo yapabilirsin."
```

**Yanıt bekliyor:**
```
Metin: "Hazır olduklarında yanıtlayacaklar."
```

**İntent geçmişi yok (Profile Modal):**
```
Metin: "Henüz hue göndermediniz."
```

### 17.3 Kurallar

- Sistem hata mesajı tonu: YOK
- "Hiçbir şey bulunamadı" ifadesi: YOK
- Her boş durum bir sonraki adımı öneriyor olmalı

---

## 18. Erişilebilirlik

### 18.1 VoiceOver / TalkBack

Her interaktif element semantic label içerir:

```
Kişi kartı:  "Ali, müsait, 2 saat önce sıcak hue gönderdi. Intent göndermek için tap et."
Preset:      "Sıcak tonu seç, yoğunluk 80%"
Send butonu: "Ali'ye sıcak hue gönder"
Foto ikonu:  "Fotoğraf ekle"
Orb preview: "Seçili: Sıcak, yoğunluk %60"
```

### 18.2 Dynamic Type

Layout tüm font boyutlarına responsive.
Minimum ölçekler korunur, overflow'a izin verilmez.

### 18.3 Renk Kontrastı

WCAG AA standardı:
- Metin / arkaplan oranı: minimum 4.5:1
- Büyük metin: minimum 3:1

Renk tek başına anlam taşımaz.
Presence durumları renk + şekil/ikon kombinasyonu ile gösterilir.

### 18.4 Reduced Motion

`prefers-reduced-motion` medya sorgusu desteklenir.
Bu modda: glow animasyonları, orb nefesi devre dışı.
Temel etkileşim animasyonları (fade) korunur.

---

## 19. Animasyon & Motion Kuralları

### 19.1 Genel Felsefe

Hiçbir şey anında belirmez.
Her şey **gelir**.

### 19.2 Easing Fonksiyonları

```
Default:          easeInOutCubic
Ekran geçişleri:  easeInOutCubic
Spring (bubble):  spring(stiffness: 280, damping: 22)
Fade:             easeOut
Orb nefesi:       easeInOutSine
```

**YASAK:** bounce, elastic, overshoot

### 19.3 Süre Referans Tablosu

```
Bottom sheet açılış:    180ms
Hue preview güncelleme: < 100ms (perceived)
Send animasyonu:        180–240ms
Orb nefesi cycle:       1200ms
Onboarding typing loop: 800ms/cycle
Sheet dismiss:          160ms
Toast fade in:          200ms
Toast fade out:         200ms
Screen transition:      300ms
Modal açılış:           200ms
```

### 19.4 Send Animasyon Detayı

```
Frame 0–80ms:   Orb scale 1.0 → 0.85 + brightness artışı
Frame 80–240ms: Orb translate Y: 0 → -200px + opacity 1 → 0
Frame 200ms:    Sheet dismiss başlar
Frame 300ms:    Toast fade in
```

### 19.5 Presence Aura Animasyonu

```
Pulse:    scale 1.0 → 1.08 → 1.0, süre 2400ms, infinite
Glow:     opacity 0.3 → 0.6 → 0.3, sync
Değişim:  Crossfade 400ms eğer presence değişirse
```

---

## 20. Mikrokopi Rehberi

### 20.1 Ton

- Sıcak, yargılamayan
- Kısa ve net
- Sosyal çerçeve, teknik değil
- Türkçe: samimi, resmi değil

### 20.2 Anahtar Metinler

| Konum | Metin |
|---|---|
| Splash tagline | "Mesaj değil, niyet gönder." |
| Onboarding A | "Bazen yazmak fazla gelir." |
| Onboarding B | "Bir renk seç. Yeter." |
| Onboarding C CTA (locked) | "Önce bir hue gönder" |
| Onboarding C CTA (active) | "Başla" |
| Home arama | "Kişi ara" |
| Intent Panel send | "Gönder" |
| Intent Panel send (foto) | "Foto + Renk Gönder" |
| Hue eksik tooltip | "Renk seçmeden gönderemezsin." |
| Undo toast | "Gönderildi — geri al" |
| "Sohbet aç" butonu | "Sohbet aç" |
| Conversation header | "[İnt] • İkisi de hazır" |
| Boş home | "Konuşmalar biri erişilebilir hale gelince başlar." |
| Kayıtsız kişi | "[İsim] henüz Hue'da değil" |
| Upload hata | "Gönderilemedi — Tekrar Dene" |
| Çevrimdışı | "İnternet bağlantısı yok" |
| Push rationale | "Hue bildirimleri için izin ver. Sessiz bildirimler de desteklenir." |
| Kamera rationale | "Fotoğraf çekmek için izin ver. Fotoğraflar EXIF'ten konum kaldırılır." |
| Hesap sil confirm | "Tüm verin silinecek. Geri alınamaz." |

### 20.3 Yasaklı İfadeler

```
"Hata oluştu"         → Yerine: "Bir sorun çıktı — tekrar dene"
"Kullanıcı bulunamadı"→ Yerine: "[İsim] henüz Hue'da değil"
"Başarısız"           → Yerine: "Gönderilemedi"
"Lütfen bekleyin"     → Yerine: [sessiz loader]
"Hiçbir şey yok"      → Yerine: bağlamsal boş durum metni
```

---

## 21. Analytics & Başarı Metrikleri

### 21.1 Temel Felsefi Fark

```
WhatsApp ölçer:   Gönderilen mesaj sayısı
Hue ölçer:        Kaçınılan mesaj sayısı
```

### 21.2 Başarı Göstergeleri

- Kullanıcı günde birden fazla intent gönderiyor ✓
- Kullanıcı sık sık acknowledge ediyor ✓
- Kullanıcı Conversation modunu nadiren açıyor ✓
- İlk hue'a kadar geçen süre kısa ✓
- Undo kullanımı düşük ✓

### 21.3 Başarısızlık Göstergeleri

- Kullanıcılar hemen yazmaya atlıyor ✗
- Intent katmanı görmezden geliniyor ✗
- Conversation / Intent oranı 1'e yaklaşıyor ✗

### 21.4 V1 Analytics Events

```javascript
onboarding_complete
intent_open         { preset_id }
intent_sent         { type: "hue" | "photo_hue", hue_id, intensity }
photo_selected
conversation_opened
text_sent
ack_sent
undo_used
settings_opened
permission_granted  { type: "push" | "camera" | "photos" }
permission_denied   { type }
```

### 21.5 KPI'lar

```
Birincil:
  - Kullanıcı başına günlük intent sayısı
  - Conversation açma oranı (intent'e göre)
  - Ack hızı (median süre)

İkincil:
  - İlk hue'a kadar geçen süre
  - Onboarding completion rate
  - 7 günlük retention
```

---

## 22. Psikolojik Tasarım İlkeleri

### 22.1 Hue'nun Azalttığı 4 Kaygı

1. **Birini rahatsız etme kaygısı** → Presence bunu önceden yanıtlar
2. **Neden arandığını bilmeme** → Intent bunu kapıda verir
3. **Yanıt süresine dair suçluluk** → Acknowledge baskısız onaylar
4. **Ton yanlış anlama** → Hue rengi tonu önceden iletir

### 22.2 Tasarım Kararı Filtresi

Her tasarım kararı bu soruyla test edilir:

> "Bu seçenek konuşmayı mı kolaylaştırıyor, yoksa anlamayı mı?"

```
Konuşma kolaylaşıyorsa → REDDET
Anlama kolaylaşıyorsa  → KABUL ET
```

### 22.3 Sosyal Baskı Azaltıcılar

```
YOK: Kırmızı unread badge
YOK: "Son görülme: 5 dakika önce"
YOK: "Yazıyor..." göstergesi
YOK: Çift mavi tik (okundu baskısı)
VAR: Soft renk bazlı presence
VAR: Bağlamsal intent sinyali
VAR: İnsan hissettiren acknowledge
```

### 22.4 Ambient Awareness (Arka Plan Farkındalık)

Kullanıcı, aktif bir etkileşim olmaksızın yakın çevresinin durumunu anlayabilmelidir.
Bu; her an müsaitlik kontrolü yapmadan pasif bir anlayış sağlar.
Presence Board bu amacı taşır.

---

## 23. Figma Deliverable Listesi

### 23.1 Frame Listesi (iPhone 14 — 393x852)

```
01. Splash
02. Onboarding A — Problem
03. Onboarding B — Keşif
04. Onboarding C — Demo (interactive)
05. Home / Presence Board — Empty State
06. Home / Presence Board — Populated
07. Intent Panel — Kapalı (collapsed)
08. Intent Panel — Hue seçili
09. Intent Panel — Foto seçili, hue bekleniyor
10. Intent Panel — Foto + Hue seçili (send aktif)
11. Hue Selector — Presets only
12. Hue Selector — Custom slider
13. Photo + Hue Preview
14. Conversation — Hue mesajları
15. Conversation — Karma (hue + metin)
16. Contact Profile Modal
17. Quick Actions (long press)
18. Settings Screen
19. Permission Modal — Push
20. Permission Modal — Kamera
21. Permission Modal — Fotoğraflar
22. Error State — Upload hatası
23. Error State — Çevrimdışı
24. Empty State — Kişi yok
25. Undo Toast
```

### 23.2 Component Ağacı

```
Foundation
  ├── Colors (tokens)
  ├── Typography
  ├── Spacing (8pt grid)
  └── Icons (SVG set)

Components
  ├── App Top Bar (variants: home / conversation / settings)
  ├── Contact Row (variants: populated / empty presence / with foto)
  ├── Hue Orb (variants: idle / selected / sending / acked)
  ├── Hue Preset (48px circle, label)
  ├── Hue Primary CTA (72px circle)
  ├── Bottom Sheet Container
  ├── Image Preview Card
  ├── Toast (variants: undo / error / info)
  ├── Modal Overlay
  ├── Text Composer (modal)
  ├── Presence Indicator (dot + aura)
  ├── Permission Modal
  └── Quick Actions Sheet
```

### 23.3 Export Kuralları

```
İkonlar:       SVG (her biri ayrı)
Logolar:       PNG 1024px @1x @2x @3x + SVG
Hue swatches:  SVG gradients
Diğer görseller: PNG @3x
```

---

## 24. Teknik Mimari Notları

### 24.1 V1 Scope

```
Platform:     iOS öncelikli (Flutter veya native)
Backend:      Minimal (device ID, intent storage, push relay)
Auth:         Device ID (V1), OAuth sonraki
Storage:      Intent log, presence state, user metadata
Realtime:     WebSocket veya APNs push
```

### 24.2 Veri Modelleri (Taslak)

**User:**
```json
{
  "device_id": "string",
  "display_name": "string",
  "avatar_url": "string | null",
  "presence": "available | busy | away | dnd | sleeping",
  "last_seen": "timestamp"
}
```

**Intent:**
```json
{
  "id": "uuid",
  "sender_id": "device_id",
  "recipient_id": "device_id",
  "hue_id": "string",
  "intensity": 0-100,
  "photo_url": "string | null",
  "created_at": "timestamp",
  "acked_at": "timestamp | null",
  "undo_at": "timestamp | null"
}
```

### 24.3 Görsel Varlık Pipeline

```
Kullanıcı fotoğraf seçer
  → Client: EXIF strip → WebP encode (~%75)
  → API: Presigned URL al
  → Upload: S3 / CloudFlare R2
  → Intent: photo_url kaydet
  → Recipient: push bildirim
```

### 24.4 Offline Kuyruğu

```
Intent oluşturulur → local SQLite / Core Data'ya kaydedilir
Network recovery → queue işlenir (FIFO)
Başarısız → retry (max 3), ardından user'a bildirim
```

---

## 25. Kabul Testi Checklist

Her sürüm öncesi aşağıdaki tüm maddeler doğrulanır:

### Onboarding

- [ ] Uygulama açılır → Onboarding ekranı görünür (ilk kez)
- [ ] Demo tamamlanmadan "Başla" aktif olmaz
- [ ] Kullanıcı demo'da hue gönderip mock ack alır
- [ ] Klavye hiç görünmez

### Home

- [ ] Presence Board chat listesi gibi görünmez
- [ ] Hiçbir kartta son mesaj metni yok
- [ ] Kart tap → Intent Panel 200ms içinde açılır
- [ ] Klavye görünmez

### Intent Panel

- [ ] Send butonu: hue seçilmemişse disabled
- [ ] Send butonu: foto var ama hue seçilmemişse disabled
- [ ] Foto seçimi hue seçimini zorunlu kılar
- [ ] Send animasyonu 400ms altında
- [ ] Undo toast 3s görünür, tap ile iptal çalışır
- [ ] Undo toast 3s sonra kaybolur

### Foto Akışı

- [ ] Foto açılınca hue seçimi zorunlu
- [ ] Hue seçilmeden send çalışmaz
- [ ] Tooltip görünür

### Conversation

- [ ] Conversation açmak için kasıtlı eylemi şart
- [ ] Metin composer varsayılan görünmez
- [ ] Metin mesajları hue mesajlarından görsel olarak ikincil
- [ ] Conversation'dan çıkış Presence Board'a döner

### Settings

- [ ] Settings hamburger veya top-left'ten erişilebilir
- [ ] Gizlilik toggle'ları açıklayıcı
- [ ] Hesap sil iki adım onay gerektirir

### Erişilebilirlik

- [ ] VoiceOver her elementin semantic label'ını okur
- [ ] Dynamic Type büyük boyutlarda layout bozulmaz
- [ ] Reduced Motion modu animasyonları devre dışı bırakır

---

## 26. Sonraki Adımlar & Yol Haritası

### V1 (TestFlight)

```
[ ] Figma: Frame + component ağacı tamamlanır
[ ] Onboarding C interaktif prototype (clickable)
[ ] Flutter skeleton: HueButton + ConversationScreen
[ ] Seed kullanıcılar ile TestFlight dağıtımı
[ ] 5–8 kullanıcı ile "ilk hue gönder" task testi
```

### V1.1

```
[ ] Telefon numarası / OAuth auth
[ ] Acknowledge animasyonları iyileştirilir
[ ] Ses bildirimleri için özel audio
[ ] Presence widget (iOS Lock Screen / Dynamic Island)
```

### V2

```
[ ] Grup presence (3–5 kişi)
[ ] Custom hue oluşturucu
[ ] Hue geçmişi / kişi bazlı insight
[ ] Android destek
```

### Uzun Vadeli

```
[ ] API: 3. taraf entegrasyonu (takvim, konum bazlı presence)
[ ] Wear OS / Apple Watch: single tap intent
[ ] Hue dili: kullanıcı özelleştirilmiş intent kütüphanesi
```

---

## Ek: Kullanıcı Test Senaryoları

### Senaryo 1: İlk Hue

**Görev:** Uygulamayı indir ve ilk Hue'yu gönder.
**Başarı kriteri:** Klavyeye basmadan tamamlanır.
**Gözlem:** Kullanıcı klavye arar mı?

### Senaryo 2: Presence Okuma

**Görev:** "Ali müsait mi?" sorusunu yanıtla.
**Başarı kriteri:** Home ekranında 5 saniye içinde cevaplanır.
**Gözlem:** Kullanıcı tap yapmak zorunda kalır mı?

### Senaryo 3: Foto + Hue

**Görev:** Bulunduğun yeri göster ve durumunu ilet.
**Başarı kriteri:** Fotoğraf + hue birlikte gönderilir, sadece fotoğraf değil.
**Gözlem:** Kullanıcı hue seçmeden göndermeyi dener mi?

### Senaryo 4: Sohbet Başlatma

**Görev:** Birine mesaj yazmak istiyorsun.
**Başarı kriteri:** Kullanıcı "Sohbet Aç"ı bulur, conversation moduna girer.
**Gözlem:** Kullanıcı intent panelinde klavye arar mı?

---

*Bu belge yaşayan bir dokümandır. Her ürün kararı buraya yansıtılır.*
*Son güncelleme: V2.0 — Tüm bölümler birleştirildi ve genişletildi.*