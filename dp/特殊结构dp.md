### trie树dp
问确定节点数，字符集大小和字符串长度上限的trie树有多少种
```cpp
void func(void)
{
	cin >> n >> m >> d;
	dp[0][1][1] = 1;
	for(int i=0;i<=d;++i)
	{
		for(int j=1;j<=n;++j)
		{
			for(int k=1;k<=j;++k)
			{
				if(!dp[i][j][k])	continue;
				int usd = m*k;
				for(int t=1;j+t<=n;++t)
				{
					if(usd < t)	break;
					dp[i+1][j+t][t] = (dp[i+1][j+t][t] + dp[i][j][k]*C[usd][t])%P;
				}
			}
		}
	}
	int ans = 0;
	for(int i=0;i<=d;++i)
	{
		for(int j=1;j<=n;++j)	ans = (ans + dp[i][n][j])%P;
	}
	cout << ans << '\n';
}
```