# Penjelasan Hitungan Satu Subnet (VLSM Kelompok K-33)

Prefix kelompok: `10.80.0.0/16`. Pembagian lengkap (17 LAN + 16 link antar-router) ada di sheet
`Pembagian IP - VLSM`, dan gambar pohonnya di `pohon_vlsm_k33.png`.

Dokumen ini menjelaskan hitungan **satu subnet** secara rinci: **A1, LAN Quarters** (subnet terbesar).

## 1. Hitungan subnet A1 (Rei > Switch-Quarters > Quarters)

| Langkah | Perhitungan | Hasil |
|---|---|---|
| 1. Kebutuhan IP | 500 host + 1 gateway (interface Rei) | **501 IP terpakai** |
| 2. Tambah alamat network dan broadcast | 501 + 2 | **503 alamat** |
| 3. Cari pangkat 2 terkecil yang ≥ 503 | 2^8 = 256 (kurang), 2^9 = 512 (cukup) | **9 bit host** |
| 4. Prefix | 32 − 9 | **/23** |
| 5. Netmask | 23 bit network = `255.255.254.0` | `255.255.254.0` |
| 6. Network ID | blok pertama dari `10.80.0.0` | **10.80.0.0** |
| 7. Ukuran blok | 2^9 | **512 alamat** (= 2 blok /24: `10.80.0.x` dan `10.80.1.x`) |
| 8. Broadcast | network + 512 − 1 | **10.80.1.255** |
| 9. Range IP yang bisa dipakai | network + 1 sampai broadcast − 1 | **10.80.0.1 – 10.80.1.254** (510 alamat) |
| 10. Gateway | IP usable pertama | **10.80.0.1** |
| 11. Sisa | 510 usable − 501 terpakai | **9 IP** |
| 12. Subnet berikutnya mulai di | network + 512 | `10.80.2.0` (dipakai A2, Comm-Net /24) |

Mengapa bukan /24? Satu blok /24 hanya punya 254 alamat usable, sedangkan kebutuhannya 501. Mengapa bukan /22?
Blok /22 berisi 1022 alamat usable, jauh melebihi kebutuhan, dan itu melanggar aturan "prefix terkecil yang muat".
Maka /23 adalah satu-satunya pilihan yang tepat.

Verifikasi cepat (Python):

```python
import ipaddress
n = ipaddress.ip_network("10.80.0.0/23")
print(n.netmask, n.broadcast_address, n.num_addresses - 2)   # 255.255.254.0 10.80.1.255 510
```

## 2. Pola yang sama untuk semua subnet

Rumusnya selalu: **IP terpakai + 2 ≤ 2^n**, lalu prefix = 32 − n.

| Contoh | Terpakai | + network & broadcast | Blok | Prefix | Sisa |
|---|---|---|---|---|---|
| A1 Quarters | 501 | 503 | 512 | /23 | 9 |
| A9 Entry-Plug + Dummy-Plug (5 host + 1 gateway) | 6 | 8 | 8 | /29 | 0 (pas) |
| A20 Link Gendo–Asuka (2 interface router, tanpa gateway) | 2 | 4 | 4 | /30 | 0 (pas) |

Subnet link antar-router hanya berisi dua interface router, jadi kolom Gateway berisi `-`.

## 3. Pohon IP dan jalur Dummy-Plug → Armisael

Pohon (`pohon_vlsm_k33.png`) membagi `10.80.0.0/16` menjadi dua di setiap percabangan sampai ke blok yang dialokasikan.
Blok abu-abu putus-putus adalah blok bebas yang tidak dipakai.

Subnet yang dilingkari merah (angka = urutan hop dari Dummy-Plug ke Armisael):

| Hop | Subnet | Network | Keterangan |
|---|---|---|---|
| 1 | A9 | `10.80.4.48/29` | LAN Entry-Plug dan Dummy-Plug (sumber) |
| 2 | A30 | `10.80.4.156/30` | Link Asuka–Ritsuko |
| 3 | A20 | `10.80.4.116/30` | Link Gendo–Asuka |
| 4 | A23 | `10.80.4.128/30` | Link Gendo–Shigeru |
| 5 | A13 | `10.80.4.80/29` | LAN Zeruel dan Armisael (tujuan) |

## 4. Catatan urutan alokasi

Alokasi mengikuti urutan dari prefix terbesar ke terkecil: /23, /24, /25, /26, /27, /28, /29, lalu /30.
Di dalam kelompok /29 ada enam subnet berukuran blok sama (8 alamat), sehingga urutan di antara mereka
tidak mengubah prefix dan tidak menimbulkan celah (fragmentasi) di ruang alamat. Setiap blok tetap sejajar
dengan kelipatan ukurannya (misalnya `10.80.4.56`, `.64`, `.72`, `.80`, `.88`, semuanya kelipatan 8).
