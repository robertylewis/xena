import xenalib.zmod algebra.group_power tactic.norm_num

local infix ` ^ ` := monoid.pow

-- sheet 5 solns

def Fib : ℕ → ℕ
| 0 := 0
| 1 := 1
| (n+2) := Fib n + Fib (n+1)

#eval Fib 10
#reduce Fib 10

def is_even (n : ℕ) : Prop := ∃ k, n=2*k
def is_odd (n : ℕ) : Prop := ∃ k, n=2*k+1

lemma even_of_even_add_even (a b : ℕ) : is_even a → is_even b → is_even (a+b) :=
begin
intros Ha Hb,
cases Ha with k Hk,
cases Hb with l Hl,
existsi k+l,
simp [Hk,Hl,add_mul],
end

lemma odd_of_odd_add_even {a b : ℕ} : is_odd a → is_even b → is_odd (a+b) :=
begin
intros Ha Hb,
cases Ha with k Hk,
cases Hb with l Hl,
existsi k+l,
simp [Hk,Hl,add_mul],
end

lemma odd_of_even_add_odd {a b : ℕ} : is_even a → is_odd b → is_odd (a+b) :=
λ h1 h2, (add_comm b a) ▸ (odd_of_odd_add_even h2 h1)


lemma even_of_odd_add_odd {a b : ℕ} : is_odd a → is_odd b → is_even (a+b) :=
begin
intros Ha Hb,
cases Ha with k Hk,
cases Hb with l Hl,
existsi k+l+1,
-- simp [mul_add,Hk,Hl,one_add_one_eq_two] -- fails!
rw [Hk,Hl,mul_add,mul_add],
change 2 with 1+1,
simp [mul_add,add_mul],
end

theorem Q1a : ∀ n : ℕ, n ≥ 1 →
  is_odd (Fib (3*n-2)) ∧ is_odd (Fib (3*n-1)) ∧ is_even (Fib (3*n)) :=
begin
intros n Hn,
cases n with m,
have : ¬ (0 ≥ 1) := dec_trivial,
exfalso,
exact (this Hn),
induction m with d Hd,
  exact ⟨⟨0,rfl⟩,⟨0,rfl⟩,⟨1,rfl⟩⟩,
change 3*nat.succ d-2 with 3*d+1 at Hd,
change 3*nat.succ d -1 with 3*d+2 at Hd,
change 3*nat.succ d with 3*d+3 at Hd,
change 3*nat.succ (nat.succ d)-2 with 3*d+4,
change 3*nat.succ (nat.succ d)-1 with 3*d+5,
change 3*nat.succ (nat.succ d) with 3*d+6,

let Hyp := Hd (begin apply nat.succ_le_succ,exact nat.zero_le d,end),
let H1 := Hyp.left,
let H2 := Hyp.right.left,
let H3 := Hyp.right.right,
have H4 : is_odd (Fib (3*d+4)),
  change Fib (3*d+4) with Fib (3*d+2)+Fib(3*d+3),
  exact odd_of_odd_add_even H2 H3,
have H5 : is_odd (Fib (3*d+5)),
  change Fib (3*d+5) with Fib (3*d+3)+Fib(3*d+4),
  exact odd_of_even_add_odd H3 H4,
have H6 : is_even (Fib (3*d+6)),
  change Fib (3*d+6) with Fib (3*d+4)+Fib(3*d+5),
  exact even_of_odd_add_odd H4 H5,
exact ⟨H4,H5,H6⟩,
end

theorem Q1b : is_odd (Fib (2017)) :=
begin
have H : 2017 = 3*673-2 := dec_trivial,
rw [H],
exact (Q1a 673 (dec_trivial)).left,
end

-- aargh stupid overloaded ^
theorem Q2 (n : ℕ) : n ≥ 2 → nat.pow 4 n > nat.pow 3 n + nat.pow 2 n :=
begin
intro H_n_ge_2,
cases n with n1,
  exfalso,revert H_n_ge_2, exact dec_trivial,
cases n1 with n2,
  exfalso,revert H_n_ge_2, exact dec_trivial,
clear H_n_ge_2,
induction n2 with d Hd,
  exact dec_trivial,
let e := nat.succ (nat.succ d),
show nat.pow 4 e*4>nat.pow 3 e*3+nat.pow 2 e*2,
change nat.pow 4 (nat.succ (nat.succ d)) > nat.pow 3 (nat.succ (nat.succ d)) + nat.pow 2 (nat.succ (nat.succ d))
with nat.pow 4 e>nat.pow 3 e+nat.pow 2 e at Hd,
exact calc
nat.pow 4 e * 4 > (nat.pow 3 e + nat.pow 2 e) * 4 : mul_lt_mul_of_pos_right Hd (dec_trivial)
... = nat.pow 3 e*4+nat.pow 2 e*4 : add_mul _ _ _
... ≥ nat.pow 3 e*3+nat.pow 2 e*4 : add_le_add_right (nat.mul_le_mul_left _ (dec_trivial)) _
... ≥ nat.pow 3 e*3+nat.pow 2 e*2 : add_le_add_left (nat.mul_le_mul_left _ (dec_trivial)) _,
end

theorem Q3a (n : ℕ) : ∃ k, (n+1)+(n+2)+(n+3)+(n+4) = 4*k+2 :=
begin
induction n with d Hd,
  existsi 2,trivial,
cases Hd with k Hk, -- why is this so horrible!
existsi k+1,
rw [nat.succ_eq_add_one],
have : ((d + 1 + (d + 2) + (d + 3) + (d + 4))+4)=(4*k+2)+4
        := Hk ▸ @eq.refl ℕ ((d + 1 + (d + 2) + (d + 3) + (d + 4))+4),
simp, -- have given in -- anything will now do.
simp at this,
rw this,
simp [add_mul],
end
--#check @eq_of_add_eq_add_right
--#check @eq.refl

--#check (by apply_instance : has_mul (fin 4))
lemma of_nat_pow : ∀ a b: ℕ, int.of_nat(a^b)=(int.of_nat a)^b :=
begin
intros a b,
induction b with k Hk,
  simp [int.of_nat_one],
unfold monoid.pow nat.pow, -- pow_nat nat.pow has_pow_nat.pow_nat monoid.pow,
--show int.of_nat (a^k*a) = (int.of_nat a) * (int.of_nat a)^k,
rw [int.of_nat_mul,mul_comm,Hk,mul_comm],
end

theorem Q3b (n : ℕ) : 8 ∣ 11^n - 3^n :=
begin
have H : ∀ (e : ℕ), 11^e ≥ 3^e,
intro e,
induction e with d Hd,
  exact dec_trivial,
exact calc 11^(nat.succ d) = 11*11^d : rfl
... ≥ 3*11^d : nat.mul_le_mul_right (11^d) (dec_trivial)
... ≥ 3*3^d : nat.mul_le_mul_left 3 Hd
... = 3^(nat.succ d) : rfl,

have H311 : @Zmod.of_int 8 3 = Zmod.of_int 11,
apply quot.sound,
existsi (1:ℤ),
exact dec_trivial,

induction n with d Hd,
  exact ⟨0,rfl⟩,

cases Hd with k Hk,
rw [←int.of_nat_eq_of_nat_iff] at Hk,
rw [int.of_nat_sub (H d),int.of_nat_mul] at Hk,
rw [of_nat_pow,of_nat_pow] at Hk,
--have : (int.of_nat 11)^d - (int.of_nat 3)^d = 8 * (int.of_nat k),
--exact Hk,
have Heq : @Zmod.of_int 8 ((3:ℤ)**d) = Zmod.of_int ((11:ℤ)**d),
apply quot.sound,
existsi (k:ℤ),
rw [mul_comm],
exact eq.symm Hk,
have H1 : @Zmod.of_int 8 ((3:ℤ)**(nat.succ d)) = Zmod.of_int (11**(nat.succ d)) := calc
Zmod.of_int ((3:ℤ)**(nat.succ d)) = (Zmod.of_int 3)**(nat.succ d) : eq.symm Zmod.of_int_pow
... = (Zmod.of_int 3) * (Zmod.of_int 3)**d : pow_succ (Zmod.of_int 3) d
... = (Zmod.of_int 3) * (Zmod.of_int (3**d)) : by rw [@Zmod.of_int_pow 8]
... = Zmod.of_int 3 * (Zmod.of_int (11**d)) : by rw [Heq]
... = Zmod.of_int 11 * (Zmod.of_int (11**d)) : by rw [H311]
... = Zmod.of_int (11**(nat.succ d)) : rfl,

unfold Zmod.of_int at H1,
have H2 := @quotient.exact ℤ (@Z_setoid 8) _ _ H1,
cases H2 with k2 Hk2,
--show (8:ℤ) ∣ 11^nat.succ d - 3^nat.succ d,
have H3 : k2 * ↑8 = (int.of_nat 11) ** nat.succ d - (int.of_nat 3) ** nat.succ d,
exact Hk2,
rw [←of_nat_pow,←of_nat_pow] at H3,
rw [←int.of_nat_sub (H (nat.succ d))] at H3,
have Hpos : k2 * ↑8 ≥ 0,
rw [H3], exact int.of_nat_nonneg (11^nat.succ d - 3^nat.succ d),
have Hpos2 : k2 ≥ 0 := nonneg_of_mul_nonneg_right Hpos (dec_trivial),
let k3 : ℕ := int.nat_abs k2,
have H4 : ↑k3 = k2 := int.nat_abs_of_nonneg Hpos2,
existsi k3,
apply int.of_nat_inj,
rw [eq.symm H3],
rw [←H4,int.of_nat_mul,mul_comm],
rw int.of_nat_eq_coe,
rw int.of_nat_eq_coe,
end

theorem Q3ca (n : ℕ) : ∃ k, (n+1)+(n+2)+(n+3)+(n+4) = 4*k+2 :=
begin
existsi (n+2),
change 4 with 1+1+1+1,
rw [add_mul,add_mul,add_mul],
simp,
end


theorem Q3cb (n : ℕ) : 8 ∣ 11^n - 3^n :=
begin
/-

What's a sensible way to do 1+x+x^2+...+x^n?

I'm still working on the details, but big_operations.lean deals with this stuff

finset.sum is the one you want (or list.sum, but the finset version has more algebraic properties on it)

-/

admit,
end

def factorial : ℕ → ℕ
| 0 := 1
| (n+1) := (factorial n) * (n+1)

theorem Q4 (n : ℕ) (H : n > 0) : factorial n < 3^n ↔ n ≤ 6 :=
begin
cases n with m,
  revert H,
  exact dec_trivial,
clear H,

cases m with m,split;exact dec_trivial,
cases m with m,split;exact dec_trivial,
cases m with m,split;exact dec_trivial,

cases m with m,split;intros,exact dec_trivial,
repeat {unfold factorial monoid.pow},{norm_num},

cases m with m,split;intros,exact dec_trivial,
repeat {unfold factorial monoid.pow},{norm_num},

cases m with m,split;exact dec_trivial,

split,
  tactic.swap,
  intro H,
  exfalso,
  revert H,
  exact dec_trivial,

intro this,exfalso,revert this,
apply not_lt_of_ge,
induction m with d Hd,
repeat {unfold factorial monoid.pow},{norm_num},

let e := nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ d)))))),
change nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ d)))))) with e,
change nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ (nat.succ d)))))) with e at Hd,

have He_ge_3 : nat.succ e ≥ 3 := by exact dec_trivial,
exact calc
factorial (nat.succ e) = factorial e * (nat.succ e) : by unfold factorial
... ≥ factorial e * 3 : nat.mul_le_mul_left _ He_ge_3
... ≥ 3^e*3 : nat.mul_le_mul_right 3 Hd
... = 3*3^e : by rw mul_comm
... = 3^nat.succ e : rfl,
end

theorem Q5 : (¬ (∃ a b c : ℕ, 6*a+9*b+20*c = 43))
             ∧ ∀ m, m ≥ 44 → ∃ a b c : ℕ, 6*a+9*b+20*c = m :=
begin
split,
  intro H,
  cases H with a H,
  cases H with b H,
  cases H with c H,
  revert H,
  cases c with c,tactic.swap,
    cases c with c,tactic.swap,
      cases c with c,tactic.swap,
        show 6*a+9*b+20*(c+3) = 43 → false,
        rw [mul_add],
        apply ne_of_gt,
        exact calc 6 * a + 9 * b + (20 * c + 20 * 3)
                = 6*a + (9*b+(20*c+20*3)) : by simp
            ... ≥ 9 * b + (20 * c + 20 * 3) : nat.le_add_left (9 * b + (20 * c + 20 * 3)) (6*a)
            ... ≥  20 * c + 20 * 3 : nat.le_add_left _ _
            ... ≥ 20*3 : nat.le_add_left _ _
            ... > 43 : dec_trivial,
      cases b with b,tactic.swap,
        show (6*a+9*(b+1)+20*2=43 → false),
        rw [mul_add],
        apply ne_of_gt,
        exact calc 6 * a + (9 * b + 9 * 1) + 20 * 2
            = (6*a+9*b)+9*1+20*2 : by simp
        ... ≥ 9*1+20*2 : nat.le_add_left _ _
        ... > 43 : dec_trivial,
      cases a with a,
        exact dec_trivial,
      show 6*(a+1) + 9 * 0 + 20 * 2 = 43 → false,
      rw [mul_add],
      apply ne_of_gt,
      exact calc 6 * a + 6 * 1 + 9 * 0 + 20 * 2
              ≥  6 * 1 + 9 * 0 + 20 * 2 : nat.le_add_left _ _
          ... > 43 : dec_trivial,

    cases b with b,tactic.swap,
      cases b with b,tactic.swap,
        cases b with b,tactic.swap,
          show (6*a+9*(b+3)+20*1=43 → false),
          rw [mul_add],
          apply ne_of_gt,
          exact calc 6 * a + (9 * b + 9 * 3) + 20 * 1
            = (6*a+9*b)+9*3+20*1 : by simp
        ... ≥ 9*3+20*1 : nat.le_add_left _ _
        ... > 43 : dec_trivial,
      cases a with a,
        exact dec_trivial,
      show 6*(a+1) + 9 * 2 + 20 * 1 = 43 → false,
      rw [mul_add],
      apply ne_of_gt,
      exact calc 6 * a + 6 * 1 + 9 * 2 + 20 * 1
              ≥  6 * 1 + 9 * 2 + 20 * 1 : nat.le_add_left _ _
          ... > 43 : dec_trivial,
      cases a with a,
        exact dec_trivial,
      cases a with a,
        exact dec_trivial,
      cases a with a,
        exact dec_trivial,
      show 6*(a+3) + 9 * 1 + 20 * 1 = 43 → false,
      rw [mul_add],
      apply ne_of_gt,
      exact calc 6 * a + 6 * 3 + 9 * 1 + 20 * 1
              ≥  6 * 3 + 9 * 1 + 20 * 1 : nat.le_add_left _ _
          ... > 43 : dec_trivial,
    cases a with a,
      exact dec_trivial,
    cases a with a,
      exact dec_trivial,
    cases a with a,
      exact dec_trivial,
    cases a with a,
      exact dec_trivial,
    show 6*(a+4) + 9 * 0 + 20 * 1 = 43 → false,
    rw [mul_add],
    apply ne_of_gt,
    exact calc 6 * a + 6 * 4 + 9 * 0 + 20 * 1
            ≥  6 * 4 + 9 * 0 + 20 * 1 : nat.le_add_left _ _
        ... > 43 : dec_trivial,


  cases b with b,tactic.swap,
    cases b with b,tactic.swap,
      cases b with b,tactic.swap,
        cases b with b,tactic.swap,
          cases b with b,tactic.swap,
            show (6*a+9*(b+5)+20*0=43 → false),
            rw [mul_add],
            apply ne_of_gt,
            exact calc 6 * a + (9 * b + 9 * 5) + 20 * 0
              = (6*a+9*b)+9*5+20*0 : by simp
          ... ≥ 9*5+20*0 : nat.le_add_left _ _
          ... > 43 : dec_trivial,
      cases a with a,
        exact dec_trivial,
      cases a with a,
        exact dec_trivial,
      show 6*(a+2) + 9 * 4 + 20 * 0 = 43 → false,
      rw [mul_add],
      apply ne_of_gt,
      exact calc 6 * a + 6 * 2 + 9 * 4 + 20 * 0
              ≥  6 * 2 + 9 * 4 + 20 * 0 : nat.le_add_left _ _
          ... > 43 : dec_trivial,
        cases a with a,exact dec_trivial,
        cases a with a,exact dec_trivial,
        cases a with a,exact dec_trivial,
        show 6*(a+3) + 9 * 3 + 20 * 0 = 43 → false,
        rw [mul_add],
        apply ne_of_gt,
        exact calc 6 * a + 6 * 3 + 9 * 3 + 20 * 0
              ≥  6 * 3 + 9 * 3 + 20 * 0 : nat.le_add_left _ _
          ... > 43 : dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    show 6*(a+5) + 9 * 2 + 20 * 0 = 43 → false,
    rw [mul_add],
    apply ne_of_gt,
    exact calc 6 * a + 6 * 5 + 9 * 2 + 20 * 0
            ≥  6 * 5 + 9 * 2 + 20 * 0 : nat.le_add_left _ _
        ... > 43 : dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    cases a with a,exact dec_trivial,
    show 6*(a+6) + 9 * 1 + 20 * 0 = 43 → false,
    rw [mul_add],
    apply ne_of_gt,
    exact calc 6 * a + 6 * 6 + 9 * 1 + 20 * 0
            ≥  6 * 6 + 9 * 1 + 20 * 0 : nat.le_add_left _ _
        ... > 43 : dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  cases a with a,exact dec_trivial,
  show 6*(a+8) + 9 * 0 + 20 * 0 = 43 → false,
  rw [mul_add],
  apply ne_of_gt,
  exact calc 6 * a + 6 * 8 + 9 * 0 + 20 * 0
          ≥  6 * 8 + 9 * 0 + 20 * 0 : nat.le_add_left _ _
      ... > 43 : dec_trivial,

-- now the opposite

-- proof that if m>=44 then it's 44+n
-- probably would have been easier to do by induction on 44

intros m Hm,
have H44 : ∃ n : ℕ, m=44+n,
  let c:ℤ := m-((44:ℕ):ℤ),
  have Hc_nonneg : c ≥ 0 := calc
  c = ↑m - ↑44 : rfl
  ... = ↑m + -↑44 : sub_eq_add_neg _ _
  ... ≥ ↑44 + -↑44 : add_le_add_right ((int.coe_nat_le_coe_nat_iff _ _).2 Hm) _
  ... = 0 : add_neg_self _,
  have H := int.nat_abs_of_nonneg Hc_nonneg,
  let n := int.nat_abs c,
  existsi n,
  apply (int.of_nat_eq_of_nat_iff _ _).1,
  rw [←int.coe_nat_eq,←int.coe_nat_eq,int.coe_nat_add,H,add_comm,sub_add_cancel],

cases H44 with n H,
rw [H],
clear Hm H m,

/- State now

n : ℕ
⊢ ∃ (a b c : ℕ), 6 * a + 9 * b + 20 * c = 44 + n

-/

-- Now need division with remainder

have H6 : ∃ q r : ℕ, n=6*q+r ∧ (r=0 ∨ r=1 ∨ r=2 ∨ r=3 ∨ r=4 ∨ r=5),
  induction n with d Hd,
    existsi 0,
    existsi 0,
    split,
      simp,
    simp,
  cases Hd with q Hd',
  cases Hd' with r HI,
  cases HI.right with H0 H15,
    existsi q,
    existsi 1,
    split,
      simp [HI.left,H0,nat.succ_eq_add_one],
    simp,
  cases H15 with H H25,
    existsi q,
    existsi 2,
    split,
--      simp [nat.succ_eq_add_one,HI.left,H1],
      rw [nat.succ_eq_add_one,HI.left,H],
    simp,
  cases H25 with H H35,
    existsi q,
    existsi 3,
    split,
      rw [nat.succ_eq_add_one,HI.left,H],
    simp,
  cases H35 with H H45,
    existsi q,
    existsi 4,
    split,
      rw [nat.succ_eq_add_one,HI.left,H],
    simp,
  cases H45 with H H5,
    existsi q,
    existsi 5,
    split,
      rw [nat.succ_eq_add_one,HI.left,H],
    simp,
  existsi q+1,
  existsi 0,
  split,
    rw [nat.succ_eq_add_one,HI.left,H5,mul_add,mul_one],
  simp,

cases H6 with q H6',
cases H6' with r H,
rw [H.left],
have Hrsmall := H.right,
clear H n,

/-

State now

q r : ℕ
Hrsmall : r = 0 ∨ r = 1 ∨ r = 2 ∨ r = 3 ∨ r = 4 ∨ r = 5
⊢ ∃ (a b c : ℕ), 6 * a + 9 * b + 20 * c = 44 + (6 * q + r)

-/

induction q with d Hd,
  cases Hrsmall with H H15,
    existsi 4,existsi 0,existsi 1,
    rw [H],exact dec_trivial,
 cases H15 with H H25,
    existsi 0,existsi 5,existsi 0,
    rw [H],exact dec_trivial,
 cases H25 with H H35,
    existsi 1,existsi 0,existsi 2,
    rw [H],exact dec_trivial,
 cases H35 with H H45,
    existsi 0,existsi 3,existsi 1,
    rw [H],exact dec_trivial,
 cases H45 with H H5,
    existsi 8,existsi 0,existsi 0,
    rw [H],exact dec_trivial,
  existsi 0,existsi 1,existsi 2,
    rw [H5],exact dec_trivial,

clear Hrsmall,

cases Hd with a Hd',
cases Hd' with b Hd'',
cases Hd'' with c H,
existsi (a+1),
existsi b,
existsi c,
rw [nat.succ_eq_add_one,mul_add,mul_add,mul_one],
rw [add_comm (6*a) 6,add_assoc,add_assoc],
rw add_assoc at H,
rw H,
simp,
end


