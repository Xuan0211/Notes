# 矩阵操作（matrix）

| OJ   |      |
| ---- | ---- |
| 解题报告 |      |
| 时间   |      |
| AC   | ☐    |
| 算法   | 树状数组 |

<https://www.cnblogs.com/genius777/p/8654126.html>

我们树状数组只需要记录这个区间修改的次数，只要奇数次就是被修改成了1，不然就还是0.

```c++
#include<cstdio>
#include<iostream>
using namespace std;
int sum[1005][1005];
int n,T;
int lowbit(int x)
{
    return ((x)&(-x));
}
void change(int x1,int y1)
{
    for(int i=x1;i<=n;i+=lowbit(i))
    {
        for(int j=y1;j<=n;j+=lowbit(j))
        {
            sum[i][j]+=1;
        }
    }
}
int query(int x,int y)
{
    int ans=0;
    for(int i=x;i>0;i-=lowbit(i))
    {
        for(int j=y;j>0;j-=lowbit(j))
        {
            ans+=sum[i][j];
        }
    }
    return ans;
}
int main()
{
    cin>>n>>T;
    while(T--)
    {
        char ord;
        cin>>ord;
        if(ord=='C')
        {

            int x1,x2,y1,y2;
            cin>>x1>>y1>>x2>>y2;
            change(x1,y1);
            change(x1,y2+1);
            change(x2+1,y1);
            change(x2+1,y2+1);
        }
        else
        {
            int x,y;
            cin>>x>>y;
            int res=query(x,y);
            printf("%d\n",(res&1));
        }
    }
    return 0;
}
```
