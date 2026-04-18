# 🎮 Escape from Labyrinth (Labirentten Kaçış) - 8086 Assembly
8086 Assembly tabanlı, VGA grafik modunda çalışan labirentten kaçış oyunu.
Bu proje, **Intel 8086/8088 Assembly** dili kullanılarak geliştirilmiş, grafik tabanlı bir labirentten kaçış oyunudur. **Marmara Üniversitesi Mikroişlemci Mimarisi ve Programlama** dersi kapsamında hazırlanmıştır.

## 🚀 Proje Özellikleri
- **Düşük Seviyeli Mimari:** Saf 8086 Assembly dili ve BIOS/DOS kesmeleri (interrupts) kullanılmıştır.
- **Grafik Modu:** VGA Video Mode 12h (640x480 çözünürlük) kullanılarak görsel arayüz oluşturulmuştur.
- **Dinamik Harita:** Haritalar dış dosyalardan (`.txt`) okunur.
- **Zorluk Seviyeleri:** Ödül sayısına göre değişen 3 farklı zorluk seviyesi mevcuttur (Easy, Medium, Hard).
- **Skor Sistemi:** En yüksek 5 skoru `scorefl.txt` dosyasında tutan kalıcı bir skor tablosu.
- **Gerçek Zamanlı Zamanlayıcı:** Oyun sırasında geçen süre ve anlık puan hesaplaması.

## 🛠️ Kullanılan Teknolojiler
- **Dil:** 8086 Assembly (x86-16)
- **Derleyici:** emu8086
- **Emülatör:** DOSBox
- **Kesmeler:** INT 10H (Video), INT 21H (DOS/Dosya), INT 16H (Klavye)

## 🎮 Nasıl Oynanır?
1. **Hareket:** Klavye üzerindeki **Ok Tuşları** ile karakterinizi (`A`) hareket ettirin.
2. **Hedef:** Duvarlara (`X`) çarpmadan ödülleri (`U`) toplayın ve çıkışa (`E`) ulaşın.
3. **Puanlama:** Her ödül **+50 puan**, her hamle **-5 puan** değerindedir.
4. **Çıkış:** İstediğiniz an **ESC** tuşuna basarak oyunu sonlandırabilirsiniz.

## 📂 Dosya Yapısı
- `lab.asm`: Ana kaynak kod dosyası.
- `map1.txt`, `map2.txt`, `map3.txt`: Oyun haritaları.
- `scorefl.txt`: Skorların kaydedildiği veri dosyası.

## 🔧 Kurulum ve Çalıştırma
1. Bu repoyu bilgisayarınıza indirin (clone).
2. `emu8086` programını açın ve `lab.asm` dosyasını yükleyin.
3. **Compile** butonuna basarak `.exe` dosyasını oluşturun.
4. Oluşturulan `.exe` dosyasını `DOSBox` veya `emu8086` emülatörü üzerinden çalıştırın.
   *(Not: .txt dosyalarının .exe ile aynı klasörde olduğundan emin olun.)*

## 👤 Geliştirici
- **İsim:** Fatih Kaya
- **Üniversite:** Marmara Üniversitesi
- **Bölüm:** Bilgisayar Mühendisliği
