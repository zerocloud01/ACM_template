## 区间dp
### 朴素区间dp
$O(n^3)$
$dp_{i,j}$ 表示从 $l$ 到 $r$ 的区间
每次枚举区间长度 - 起始点 - 间断点
> 枚举区间端点会比枚举起点$+$长度好实现一些
```cpp
for(int i=2;i<=n;++i)
	{
		for(int j=1;j+i-1<=n;++j)
		{
			for(int k=j;k<j+i-1;++k)
			{
				dp[j][j+i-1] = min(dp[j][j+i-1],dp[j][k]+dp[k+1][j+i-1]+x);
			}
		}
	}
```