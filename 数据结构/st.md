## st表
```cpp
void init(void)
{
	for(int i=1;i<=n;++i)	st[i][0] = a[i];
	for(int i=1;i<=D;++i)
	{
		for(int j=1;j+(1<<i)-1<=n;++j)
		{
			st[j][i] = CMP(st[j][i-1],st[j+(1<<(i-1))][i-1]);
		}
	}
}

int find(int l,int r)
{
	int k = log2(r-l+1);// 最好预处理log2
	return CMP(st[l][k],st[r-(1<<k)+1][k])
}
```