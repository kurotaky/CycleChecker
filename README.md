# サイクルレベル
## 概要
サイクルチェンジャーのWeb APIからレベルデータを受信、
Blutoothを使用してサイクルベースと接続し、デジタルI/OのHighとLowを切り替える。

## スペック
* Swift 3.0.2
* iOS 10.1
* iPhone6

## 操作方法
* 画面を指1本でタップ: Web APIへHTTP通信を行い、レベルデータを受信する
* 画面を2本指でタップ: デジタルI/OのHighとLowを決められた4パターンで順番に切り替える
* 2本指でスワイプ: 全てのデジタルI/OをLowにする
* 4本指でスワイプ: デモ用にLevelをMAXにして、500ms毎に光り方のパターンを切り替える
