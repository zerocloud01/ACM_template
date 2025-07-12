```cpp
void init(void)
{
	for(int i=1;i<=n;++i)	smx[i][0] = smn[i][0] = ds[i];
	for(int i=1;i<=20;++i)
	{
		for(int j=1;j+(1<<i)-1<=n;++j)
		{
			smx[j][i] = max(smx[j][i-1],smx[j+(1<<(i-1))][i-1]);
			smn[j][i] = min(smn[j][i-1],smn[j+(1<<(i-1))][i-1]);
		}
	}
}

PII find(int l,int r)
{
	int k = log2(r-l+1);
	return {max(smx[l][k],smx[r-(1<<k)+1][k]),min(smn[l][k],smn[r-(1<<k)+1][k])};
}
```