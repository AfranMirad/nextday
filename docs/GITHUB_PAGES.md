# GitHub Pages — NextDay gizlilik URL

Bu klasör (`docs/`) GitHub Pages kaynağıdır.

## 1) GitHub'da repo oluştur

1. https://github.com/new
2. Repository name: `nextday` (önerilir)
3. Public
4. README ekleme (bizde zaten var)
5. Create repository

## 2) Bilgisayardan ilk push

PowerShell:

```bat
cd C:\Users\muhfa\source\repos\GunSayac
git init
git add .
git commit --trailer "Co-authored-by: Cursor <cursoragent@cursor.com>" -m "Initial NextDay app and privacy pages"
git branch -M main
git remote add origin https://github.com/KULLANICI_ADIN/nextday.git
git push -u origin main
```

`KULLANICI_ADIN` yerine GitHub kullanıcı adınızı yazın.

## 3) Pages'i aç

1. Repo → **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: `main`
4. Folder: **/docs**
5. Save

1-2 dakika bekleyin.

## 4) Play Console'a yapıştırılacak URL

```text
https://KULLANICI_ADIN.github.io/nextday/privacy.html
```

Örnek (kullanıcı `AfranMirad` ise):

```text
https://AfranMirad.github.io/nextday/privacy.html
```

Tarayıcıda açılıyorsa Play'e ekleyin.