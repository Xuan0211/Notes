# 【环形DP+四边形不等式】石子归并

| OJ   | 洛谷         |
| ---- | ---------- |
| 解题报告 |            |
| 时间   | 2022/12/10 |
| AC   | ☑          |
| 算法   | DP         |

## 石子归并：

<https://www.luogu.com.cn/problem/P1880>

### 题目描述

在一个**圆形操场的四周摆放 **$N$** 堆石子**，现要将石子有次序地合并成一堆，规定每次只能选相邻的 $2$ 堆合并成新的一堆，并将新的一堆的石子数，记为该次合并的得分。

试设计出一个算法,计算出将 $N$ 堆石子合并成 $1$ 堆的**最小得分和最大得分**。

#### 变形:环形DP

<https://blog.csdn.net/hungry1234/article/details/120122645>

断环为链

思路：将一个环复制一倍成为一条链。每次都可以枚举从i出发，最长为n-1的区间

其中核心有：

```c++
for (int l = 2; l <= n; l++)
  {
    for (int i = 1; i <= 2*n - l + 1; i++)
    {
      int j = i + l - 1;
      for (int k = s[i][j - 1]; k <= s[i + 1][j]; k++)
      {
        int t;
        t = dp[i][k] + dp[k + 1][j] + cost(i, j);
        if (dp[i][j] > t)
        {
          dp[i][j] = t;
          s[i][j] = k;
        }
      }
    }
  }
```

### 错误尝试：

#### 对max方程仍然使用四边形不等式

可以发现这是不满足的

#### 将cost取-,使其仍然满足四边形不等式？

发现会破坏cost 的单调性

## AC代码

```c++
#include <bits/stdc++.h>
using namespace std;
#define INF 20000
int p[220];
int cost(int l, int r)
{
  int sum = 0;
  for (int i = l; i <= r; i++)
  {
    sum += p[i];
  }
  return sum;
}
int main()
{
  int n;
  int dp[220][220];
  int dp2[220][220];
  int s[220][220];
  int s2[220][220];
  memset(dp, 0, sizeof(dp));
  memset(s, 0, sizeof(s));
  memset(dp2, 0, sizeof(dp2));
  memset(s2, 0, sizeof(s2));
  cin >> n;
  for (int i = 1; i <= n; i++)
  {
    cin >> p[i];
    p[i + n] = p[i];
  }
  for (int i = 1; i <= 2*n; i++)
  {
    for (int j = 1; j <= 2*n; j++)
    {
      dp[i][j] = INF;
    //  dp2[i][j] = 0;
    }
    s[i][i] = i;
    dp[i][i] = 0;
    s2[i][i] = i;
    //dp2[i][i] = 0;
  }
  for (int l = 2; l <= n; l++)
  {
    for (int i = 1; i <= 2 * n - l + 1; i++)
    {
      int j = i + l - 1;
      for (int k = s[i][j - 1]; k <= s[i + 1][j]; k++)
      {
        int t;
        t = dp[i][k] + dp[k + 1][j] + cost(i, j);
        if (i <= k && (k + 1) <= j && dp[i][j] > t)
        {
          dp[i][j] = t;
          s[i][j] = k;
        }
      }
      //对于求max并没有使用四边形不等式优化
      //这个问题已经在问可怜的老干部了
      for (int k = i; k <= j - 1; k++)
      {
        int t2;
        t2 = dp2[i][k] + dp2[k + 1][j] + cost(i, j);
        if (i <= k && (k + 1) <= j && dp2[i][j] < t2)
        {
          dp2[i][j] = t2;
          s2[i][j] = k;
        }
      }
    }
  }
  int minn = INF;
  int maxx = 0;
  for (int i = 1; i <= n; i++)
  {
    minn = min(dp[i][i + n - 1], minn);
    maxx = max(dp2[i][i + n - 1], maxx);
  }
  cout << minn<<endl<<maxx;
  return 0;
}
```

![](image/image_z2J7hlRYK9.png)

## 一组用四边形不等式优化MAX会WA的测试样例

#### input

```c++
46
16 4 14 12 0 3 11 8 18 2 6 8 6 7 13 7 8 14 11 2 16 12 16 0 8 1 3 10 7 16 0 16 11 17 13 18 5 15 0 12 19 0 0 5 3 1 
```

[P1880\_2.in](file/P1880_2_HGVVZz_BzM.in)

#### output

```c++
2087
10554
```

[P1880\_2.out](file/P1880_2_1o9WMEgOPq.out)
