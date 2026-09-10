# 一份 Navier–Stokes 局部正則性 Lean 形式化的筆記

本倉庫收錄四份文件。它**不含**形式化本體，那部分還不到可以公開的程度。這裡放的是能夠獨立成立的
部分：一份對他人公開成果的獨立驗證、一份關於如何為 AI 產生的 Lean 設閘門的方法筆記，
以及一條我們卡住、希望有人指點的開放 Lean 陳述。

**請先讀宣稱範圍。** [`CLAIM_SCOPE.zh-TW.md`](CLAIM_SCOPE.zh-TW.md) 說明底層工作證明了什麼，
以及用更長的篇幅說明它沒有證明什麼。簡短版：它證明了 Caffarelli–Kohn–Nirenberg 理論中的一個
量化二選一，以及底下的奇異積分機器。它**沒有**證明 ε-regularity、**沒有**證明部分正則性、
與全域存在性和光滑性無關、與 Clay 千禧年問題無關。所有東西都條件於一個目前只展示過零解的解類別。

## 四份文件

**[`OPEN_PROBLEM_CHAIN_RULE.md`](OPEN_PROBLEM_CHAIN_RULE.md)（英文）** — 最希望得到回覆的一份。
內容是一條鏈規則：光滑外函數複合上一個只知道具有弱梯度的向量場，寫成 Lean 陳述。我們已經把
未正則化的情形歸約到這一條，而且把該歸約反過來寫的控制檔無法編譯，表示這個歸約帶有實質內容。
我們也量測到 mathlib 目前在幾個顯而易見的名字底下都沒有弱導數或 Sobolev 理論，也沒有
mollification。如果我們漏看了現成的路，我們寧願被糾正——錯誤的「缺席宣稱」是這個專案記錄裡
最常見的錯誤。

**[`AUDIT_OPENAI_NAVIERSTOKES_EULER.md`](AUDIT_OPENAI_NAVIERSTOKES_EULER.md)（英文）** —
對 `openai/NavierStokesAndEuler` 的獨立稽核，在單一機器上執行，附上可重跑的指令。結論：它的陳述
與 `google-deepmind/formal-conjectures` 上游在指定 commit 上逐位元組相同；週期情形的壓力條件符合
Clay 官方勘誤；信任基底裡沒有公理、沒有 `native_decide`、除了有文件說明的佔位以外沒有 `sorry`；
兩個目標都建置成功，合計 20010 個 job，四條定理都只依賴 `propext`、`Classical.choice`、
`Quot.sound`。文中也保留了我們曾回報、後來追出是自己並行建置造成的一次建置失敗——把撤回刪掉的話，
那就不叫撤回。

**[`GATING_AI_GENERATED_LEAN.md`](GATING_AI_GENERATED_LEAN.md)（英文）** — 我們如何為 AI 代理寫的
單位設閘門，以及我們親眼看過這個閘門被騙過的每一種方式：harness 明明沒跑卻報綠、公理檢查被換行的
日誌騙過、控制檔在數學上壞掉之前就先在語法上壞掉、變異之後陳述仍然為真、裝飾性假設、
以及會自己摘要輸出的 shell 工具。最後一節講變異控制根本做不到的事：偵測一條空洞的陳述。

## 為什麼是這三份而不是程式碼

形式化本體很大，而且大部分是一條已被取代的路線的紀錄。把它整包倒出來，沒有人能在十分鐘內評估它，
而且正好會招來宣稱範圍那一頁想要防止的過度解讀。這三份文件可以各自被檢查：稽核可以重跑它的指令，
方法筆記可以對照讀者自己的經驗，開放問題則任何熟悉相關 mathlib 的人都能判斷。

## 聯絡

請開 issue。對我們來說，糾正比同意有用，尤其是在開放問題上，以及稽核中任何無法重現的地方。

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
