# robosys2026

[![YOLOInspect Tests](https://github.com/skt-0628/robosys2026/actions/workflows/test.yml/badge.svg)](https://github.com/skt-0628/robosys2026/actions/workflows/test.yml)

## 概要

`yoloinspect` は、YOLO11を使用して画像に写っている物体を検出するコマンドです。

画像ファイルを指定すると、検出された物体の種類と個数を集計して表示します。

標準入力とコマンドライン引数の両方に対応しています。

## 主な機能

- YOLO11による画像内の物体検出
- 検出した物体の種類と個数の集計・表示

## 必要環境

- Ubuntu 22.04以降
- Python 3.8以降
- pip
- Python venv
- インターネット接続（初回のモデルダウンロード時）

## インストール

以下のコマンドでリポジトリを取得し、必要なライブラリをインストールします。

```bash
sudo apt update
sudo apt install -y git python3-venv

git clone https://github.com/skt-0628/robosys2026.git
cd robosys2026

python3 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip
python -m pip install "ultralytics==8.3.0"

chmod +x yoloinspect
```

インストール後、以下のコマンドで実行できます。

```bash
./yoloinspect --help
```

Ultralyticsのインストール時に、必要なPyTorchなどの依存ライブラリもインストールされます。

初回実行時には、YOLO11nの学習済みモデルが自動的にダウンロードされます。

別のターミナルで使用する場合は、リポジトリ内で以下のコマンドを実行して仮想環境を有効にしてください。

```bash
source .venv/bin/activate
```

## 使用方法

### 1. 画像ファイルを直接指定

コマンドライン引数に画像ファイルのパスを指定します。

```bash
./yoloinspect test_image.jpg
```

### 2. 標準入力から画像を指定

パイプを使用して画像ファイルのパスを渡すこともできます。

```bash
echo "test_image.jpg" | ./yoloinspect
```

### 3. 信頼度しきい値を指定

`-t` オプションで検出の信頼度しきい値を指定できます。

```bash
./yoloinspect -t 0.7 test_image.jpg
```

しきい値は0.0から1.0の範囲で指定できます。

値を大きくすると、より高い信頼度の検出結果だけが表示されます。

## 実行例

```text
YOLO Object Detection Results
-----------------------------
bus: 1
person: 3
Total objects: 4
```

※上記は出力形式の例です。検出結果は入力画像によって異なります。

## エラー処理

以下のような不正な入力に対してエラーを表示します。

- 画像ファイルが存在しない場合
- 画像ファイルが指定されていない場合
- 信頼度しきい値が0.0から1.0の範囲外の場合
- 不正な入力が指定された場合

## 自動テスト

以下のコマンドで自動テストを実行できます。

```bash
chmod +x test_yoloinspect.bash
./test_yoloinspect.bash
```

以下の5項目をテストします。

1. 通常の画像ファイルの検出
2. 存在しない画像ファイルのエラー処理
3. 不正なしきい値のエラー処理
4. 画像パス未指定時のエラー処理
5. 標準入力からの画像パス指定

すべて成功すると、以下のように表示されます。

```text
PASS: 5
FAIL: 0
```

GitHub Actionsにより、mainブランチへのpushおよびpull request時に自動テストが実行されます。

## ライセンス・著作権

このソフトウェアはBSD-3-Clauseライセンスの下で公開されています。

Copyright (c) 2026 Takumi Sakata
