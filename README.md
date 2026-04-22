# Labirentten Kacis - 8086 Assembly

8086 Assembly tabanli, VGA grafik modunda calisan labirentten kacis oyunu.

Bu proje, **Intel 8086/8088 Assembly** dili kullanilarak gelistirilmis, grafik tabanli bir labirentten kacis oyunudur. **Marmara Universitesi Mikroislemci Mimarisi ve Programlama** dersi kapsaminda hazirlanmistir.

## Proje Ozellikleri

- **Dusuk Seviyeli Mimari:** Saf 8086 Assembly dili ve BIOS/DOS kesmeleri (interrupts) kullanilmistir.
- **Grafik Modu:** VGA Video Mode 12h (640x480 cozunurluk) kullanilarak gorsel arayuz olusturulmustur.
- **Dinamik Harita:** Haritalar dis dosyalardan (`.txt`) okunur. Uc farkli harita secenegi mevcuttur.
- **Zorluk Seviyeleri:** Odul sayisina gore degisen 3 farkli zorluk seviyesi mevcuttur:
  - **Kolay:** 15 odul
  - **Orta:** 10 odul
  - **Zor:** 5 odul
- **Anlik Skor Gostergesi:** Oyun sirasinda her hamlede guncellenen puan ekranda gosterilir. Her hamle **-5 puan**, her odul **+50 puan** degerindedir.
- **Gercek Zamanli Zamanlayici:** Oyun sirasinda gecen sure (dakika:saniye) ekranin alt kisminda anlik olarak hesaplanir.
- **Basitlestirilmis Menu:** Yeni Oyun, Harita Secimi ve Zorluk Seviyesi olmak uzere 3 ana menu secenegi bulunur.

## Kullanilan Teknolojiler

- **Dil:** 8086 Assembly (x86-16)
- **Derleyici:** emu8086
- **Emulator:** DOSBox
- **Kesmeler:**
  - INT 10h (Video islemleri)
  - INT 21h (DOS/Dosya islemleri)
  - INT 16h (Klavye okuma)
  - INT 15h (Bekleme/Gecikme)

## Nasil Oynanir?

1. **Hareket:** Klavye uzerindeki **Ok Tuslari** ile karakterinizi (`A`) hareket ettirin.
2. **Hedef:** Duvarlara (`X`) carpmadan odulleri (`U`) toplayin ve cikisa (`E`) ulasin.
3. **Puanlama:** Her odul **+50 puan**, her hamle **-5 puan** degerindedir.
4. **Cikis:** Istediginiz an **ESC** tusuna basarak oyunu sonlandirabilirsiniz.
5. **Menu:** Oyuna baslamadan once harita ve zorluk seviyesi secimi yapabilirsiniz.

## Dosya Yapisi

- `lab.asm`: Ana kaynak kod dosyasi.
- `harita1.txt`, `harita2.txt`, `harita3.txt`: Oyun haritalari (20x22 karakter matrisi).
- `lab.exe`: Derlenmis calistirilabilir dosya.

## Kurulum ve Calistirma

1. Bu repoyu bilgisayariniza indirin (clone).
2. `emu8086` programini acin ve `lab.asm` dosyasini yukleyin.
3. **Compile** butonuna basarak `.exe` dosyasini olusturun.
4. Olusan `.exe` dosyasini `DOSBox` veya `emu8086` emulatoru uzerinden calistirin.

> **Not:** `harita1.txt`, `harita2.txt` ve `harita3.txt` dosyalarinin `.exe` ile ayni klasorde oldugundan emin olun.

## Gelistirici

- **Isim:** Fatih Kaya
- **Universite:** Marmara Universitesi
- **Bolum:** Bilgisayar Muhendisligi
