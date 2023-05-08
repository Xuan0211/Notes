# 均匀分布Uniform distribution

# 均匀分布

### 概率密度

$$
f(x)=\left\{\begin{array}{ll}\frac{1}{b-a} & a<x<b \\ 0 & \text { 其他 }\end{array}\right.
$$

### [数学期望](../数学期望/数学期望.md "数学期望")

$$
\begin{aligned} E(x) & =\int_{a}^{b} x \cdot \frac{1}{b-a} d x \\ & =\frac{1}{b-a} \int_{a}^{b} x d x \\ & =\frac{1}{2} \frac{b^{2}-a^{2}}{ b-a} \\ & =\frac{1}{2}(a+b)\end{aligned}
$$

### [方差](../方差/方差.md "方差")

$$
\begin{aligned} E\left(x^{2}\right) & =\int_{a}^{b} x^{2} \cdot \frac{1}{b-a} d x \\ & =\frac{1}{b-a} \cdot \frac{1}{3} \cdot\left(b^{3}-a^{3}\right) \\ & =\frac{1}{3}\left(a^{2}+b^{2}+a b\right) \end{aligned}
$$

$$
\begin{aligned} D(x) & =\frac{1}{3}\left(a^{2}+b^{2}+a b\right)-\frac{1}{4}\left(a^{2}+b^{2}+2 a b\right) \\ & =\frac{4 a^{2}+4 b^{2}+4 a b-3 a-3 b^{2}-6 a b}{12} \\ & =\frac{\left(a \cdot b )^{2}\right.}{12}\end{aligned}
$$

> ✒️立方差公式
>
> $$
> a^{3}-b^{3}=(a-b)\left(a^{2}+a b+b^{2}\right)
> $$
>
> 完全立方差公式
>
> $$
> (a-b)^{3}=(a-b)(a-b)(a-b)=\left(a^{2}-2 a b+b^{2}\right)(a-b)=a^{3}-3 a^{2} b+3 a b^{2}-b^{3}
> $$
