# JSP-000301 · 提交材料包

> **红线声明**：本文件与 `Jsp000301.lean` 全部由 AI 完成形式化，仅作为证明贡献证据。
> **claim / 身份核验 / USDC 收款地址 / 收奖金 永远由提交人本人操作，AI 不参与任何链上动作。**

---

## 1. 官方题面（完整原文）

- **题号**：JSP-000301
- **标题**：*If two consecutive positive integers are powerful, must at least one be a perfect square?*
- **数学领域**：Number theory / Powerful numbers
- **题面描述**：若两个连续正整数都是 powerful 数（幂丰数），是否其中至少有一个是完全平方数？
- **官方状态**：Solved（证明者 Solomon W. Golomb，1970 年反例 [Go70]）

官方复核记录（Review notes）原文：

> Disproved: 12167 = 23³ and 12168 = 2³ × 3² × 13² are consecutive powerful numbers,
> and neither is a perfect square. A powerful number has exponent at least two in every
> prime factor. The displayed factorizations verify this property for 12167 and 12168.
> Both lie strictly between 110² = 12100 and 111² = 12321, so neither is a square.

---

## 2. 解答（Golomb 1970 反例）

结论：**否（No）**。存在两个连续正整数，二者都是 powerful 数，但都不是完全平方数：

```
12167 = 23³
12168 = 2³ · 3² · 13²
12168 = 12167 + 1
```

两者均非完全平方数：12167 的素因子 23 的指数为 3（奇数），12168 的素因子 2 的指数为 3（奇数）。
这构成对原命题的否定，给出了最小的反例对 `(12167, 12168)`。

数学解出处（随 PR 提供，公开可查）：

- **[Go70]** Solomon W. Golomb, *Powerful numbers*, Amer. Math. Monthly 77(8) (1970), 848–852.
- **[Wa76]** W. A. Webb, *Consecutive integer pairs of powerful numbers and related Diophantine equations*, Fibonacci Quart. (1976), 111–116.
- **[Gu04]** R. K. Guy, *Unsolved problems in number theory* (2004), xviii+437.
- 归因来源：https://www.erdosproblems.com/latex/365

---

## 3. Lean 形式化贡献

- **证明文件**：`Jsp000301.lean`（根模块 `Jsp000301`，命名空间 `Jsp000301`）
- **主定理**：
  ```lean
  theorem jsp000301 :
      (12168 : ℕ) = 12167 + 1
      ∧ IsPowerfulNat 12167
      ∧ IsPowerfulNat 12168
      ∧ ¬IsSquare (12167 : ℕ)
      ∧ ¬IsSquare (12168 : ℕ)
  ```
- **`IsPowerfulNat` 定义（与题面严格一致）**：
  ```lean
  def IsPowerfulNat (n : ℕ) : Prop :=
    n ≠ 0 ∧ ∀ p : ℕ, p.Prime → (n.factorization p = 0 ∨ 2 ≤ n.factorization p)
  ```
  即：每个素因子的指数至少为 2（等价于 p² ∣ n）。
- **`IsSquare` 说明**：本 commit 的 mathlib 中平方数判定为**泛型**定义
  `IsSquare (a : α) : Prop := ∃ r, a = r * r`，位于 `Mathlib.Algebra.Group.Even`，
  **无 `Nat.IsSquare` 命名空间变体**。证明直接复用该 Mathlib 泛型定义，未自定义平方判定。
- **关键 mathlib 引理**（mathlib commit `ba22a8986c7bb38a6f340cc151b98692dc4ce6bf`）：
  - `Nat.isSquare_iff_even_factorization`：`IsSquare n ↔ ∀ p:ℕ, p.Prime → Even (n.factorization p)`
  - `Nat.Prime.factorization_pow`：`(p^k).factorization = single p k`
  - `Nat.factorization_mul`：`factorization (a*b) = factorization a + factorization b`
  - `Finsupp.add_apply`：`(g₁+g₂) a = g₁ a + g₂ a`
  - `Finsupp.single_eq_same` / `Finsupp.single_eq_of_ne`

---

## 4. 构建命令

在工程根目录执行：

```bash
lake clean
lake build
```

构建成功后在 `.lake/build/lib/lean/` 下生成 `Jsp000301.olean`，且全过程零 error、零 sorry、零 warning。

---

## 5. 运行环境

- **Lean 版本**：4.34.0（`lean-toolchain` 锁定 `leanprover/lean4:v4.34.0`）
- **mathlib commit**：`ba22a8986c7bb38a6f340cc151b98692dc4ce6bf`

---

## 6. 文件清单

| 文件 | 作用 |
| --- | --- |
| `Jsp000301.lean` | 证明源码（主定理 `jsp000301`） |
| `Jsp000208.lean` | 工程根模块，含 `import Jsp000301` |
| `lakefile.toml` | 工程配置（库名 `Jsp000301`） |
| `lean-toolchain` | 工具链锁定 v4.34.0 |
| `SUBMIT_JSP000301.md` | 本提交材料包 |

---

## 7. 申领步骤（提交人本人执行，AI 不参与）

1. 将本工程推到**你自己的 GitHub 仓库**（fork 官方 awards 仓库后，在 fork 中更新对应 catalog 条目并开 PR）。
2. 在 PR 中提供：仓库 URL、分支、所选提交的 40 位 commit SHA。
3. 随 PR 附上第 2 节的数学解证据（Golomb 1970 等公开文献）。
4. 提交后走 14 天公示 → 你本人完成 claim + 身份核验 → 官方发奖（USDC 至**你本人**地址）。

---

## 8. 当前资格状态

- 题库索引当前显示 `Eligible to claim = No` —— 这仅表示"尚未形式化"的当前态。
- 本包已补全 verified Lean 证明，该题即翻 `Eligible = Yes`、两申领状态变 `Unclaimed`，**提交人即可申领**。
- 数学解归因：Solomon W. Golomb (1970)；Lean 形式化：AI 完成（提交/申领人为你本人）。
