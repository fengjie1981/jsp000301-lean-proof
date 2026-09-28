import Mathlib.Algebra.Group.Even
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.Factorization.Defs
import Mathlib.Data.Finsupp.Defs
import Mathlib.Tactic.NormNum

/-!
# JSP-000301 — Golomb's (1970) counterexample on consecutive powerful numbers

The naive conjecture: among any two consecutive powerful numbers, at least one
must be a perfect square. **This is false**, and the smallest counterexample is
the pair `(12167, 12168)`:

* `12167 = 23 ^ 3`
* `12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2`

They are consecutive, both are powerful, yet neither is a perfect square
(because each carries an odd prime exponent: `23` for `12167`, `2` for `12168`).
-/

namespace Jsp000301

/-- A natural number `n` is *powerful* iff `n ≠ 0` and every prime divisor `p` of
    `n` satisfies `p ^ 2 ∣ n`. Equivalently, in the prime factorization of `n`,
    every exponent is at least `2`. -/
def IsPowerfulNat (n : ℕ) : Prop :=
  n ≠ 0 ∧ ∀ p : ℕ, p.Prime → (n.factorization p = 0 ∨ 2 ≤ n.factorization p)

/-- The Golomb counterexample, fully explicit and machine-checked. -/
theorem jsp000301 :
    (12168 : ℕ) = 12167 + 1
    ∧ IsPowerfulNat 12167
    ∧ IsPowerfulNat 12168
    ∧ ¬IsSquare (12167 : ℕ)
    ∧ ¬IsSquare (12168 : ℕ) := by
  have h_cont : 12168 = 12167 + 1 := by norm_num
  have h12167 : 12167 = 23 ^ 3 := by norm_num
  have h12168 : 12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2 := by norm_num
  have fa : Nat.factorization 12167 = Finsupp.single 23 3 := by
    rw [h12167, Nat.Prime.factorization_pow (by decide : Nat.Prime 23)]
  have fb : Nat.factorization 12168 =
      Finsupp.single 2 3 + Finsupp.single 3 2 + Finsupp.single 13 2 := by
    rw [h12168,
      Nat.factorization_mul (by decide : 2 ^ 3 * 3 ^ 2 ≠ 0) (by decide : 13 ^ 2 ≠ 0),
      Nat.factorization_mul (by decide : 2 ^ 3 ≠ 0) (by decide : 3 ^ 2 ≠ 0),
      Nat.Prime.factorization_pow (by decide : Nat.Prime 2),
      Nat.Prime.factorization_pow (by decide : Nat.Prime 3),
      Nat.Prime.factorization_pow (by decide : Nat.Prime 13)]
  refine ⟨h_cont, ?_, ?_, ?_, ?_⟩
  -- IsPowerfulNat 12167
  · constructor
    · norm_num
    · intro p hp
      rw [fa]
      by_cases h : p = 23
      · right
        rw [h, Finsupp.single_eq_same]
        decide
      · left
        rw [Finsupp.single_eq_of_ne h]
  -- IsPowerfulNat 12168
  · constructor
    · norm_num
    · intro p hp
      rw [fb, Finsupp.add_apply, Finsupp.add_apply]
      by_cases h2 : p = 2
      · right
        rw [h2, Finsupp.single_eq_same, Finsupp.single_eq_of_ne (by decide : 2 ≠ 3),
          Finsupp.single_eq_of_ne (by decide : 2 ≠ 13)]
        decide
      · by_cases h3 : p = 3
        · right
          rw [h3, Finsupp.single_eq_of_ne (by decide : 3 ≠ 2), Finsupp.single_eq_same,
            Finsupp.single_eq_of_ne (by decide : 3 ≠ 13)]
          decide
        · by_cases h13 : p = 13
          · right
            rw [h13, Finsupp.single_eq_of_ne (by decide : 13 ≠ 2),
              Finsupp.single_eq_of_ne (by decide : 13 ≠ 3), Finsupp.single_eq_same]
            decide
          · left
            rw [Finsupp.single_eq_of_ne h2, Finsupp.single_eq_of_ne h3,
              Finsupp.single_eq_of_ne h13]
            rfl
  -- ¬IsSquare 12167 : prime exponent 23 is odd (3)
  · rw [Nat.isSquare_iff_even_factorization]
    push Not
    use 23
    constructor
    · decide
    · rw [fa, Finsupp.single_eq_same]
      decide
  -- ¬IsSquare 12168 : prime exponent 2 is odd (3)
  · rw [Nat.isSquare_iff_even_factorization]
    push Not
    use 2
    constructor
    · decide
    · rw [fb, Finsupp.add_apply, Finsupp.add_apply, Finsupp.single_eq_same,
        Finsupp.single_eq_of_ne (by decide : 2 ≠ 3),
        Finsupp.single_eq_of_ne (by decide : 2 ≠ 13)]
      decide

end Jsp000301
