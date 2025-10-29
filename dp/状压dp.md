[TOC]
## 状压dp
- `__builtin_popcount(x)` 二进制 $1$ 的个数，O(1)

### 子集dp
`sos_dp`
一个集合的状态，由其所以子集转移而来，为了防止重复记录，一般每次只新增一个元素。

#### 例题
在一个有 $\textstyle n$ 个城市的国家中，这些城市之间有 $\textstyle n-1$ 条双向道路相连，形成一棵树。
你正在访问这个国家，并且有 $\textstyle m$ 条特定的道路是你**必须经过**的。

旅行社提供了 $\textstyle k$ 条可选的旅游路线。每条路线从城市 $\textstyle s_i$ 出发，沿最短路径到达城市 $\textstyle t_i$。

你的目标是从这 $\textstyle k$ 条路线中选择**尽可能少的路线**，以确保所有 $\textstyle m$ 条关键道路都被至少经过一次。

请计算：

1. 你最少需要选择的路线数量；
2. 达到该最小数量的不同选择方案数（答案对 $\textstyle 998244353$ 取模）。

一个“方案”定义为你选择的旅游路线的集合。
当且仅当存在一条路线在某个方案中被选中，而在另一个方案中未被选中时，这两个方案被视为不同。

如果无法经过所有指定的关键道路，则输出 $\textstyle -1$。

题目保证答案对 $\textstyle 998244353$ 取模后不为零。

```cpp

int n,m,k;
map<PII,int> mp;
vector<int> v[N];
int d[N], dp[M+10], f[N], inf[N], cnt[D];

int qpow(int a,int b)
{
    int res = 1;
    while(b)
    {
        if(b&1)    res = (res*a)%P;
        a = a*a%P;
        b >>= 1;
    }
    return res;
}

int inv(int x)
{
    return qpow(x,P-2);
}

int C(int x,int y)
{
    // if(y > x)    return 0;
    return f[x]*inf[y]%P*inf[x-y]%P;
}

void dfs(int p,int lp)
{
	d[p] = d[lp];
	if(mp.count({p,lp}))    d[p] |= (1<<mp[{p,lp}]);
	for(auto &i : v[p])
	{
	    if(i != lp)    dfs(i,p);
	}
}

void func(void)
{
    cin >> n >> m >> k;
    int all1 = (1<<m)-1;
    vector<PII> road(n+1);
    vector<int> a(k+1);
    for(int i=2;i<=n;++i)
    {
        int x,y;    cin >> x >> y;
        road[i-1] = {x,y};
        v[x].push_back(y);
        v[y].push_back(x);
    }
    for(int i=1;i<=m;++i)
    {
        int z;    cin >> z;
        auto [x,y] = road[z];
        mp[{x,y}] = mp[{y,x}] = i-1;
    }
    dfs(1,0);
    for(int i=1;i<=k;++i)
    {
        int x,y;    cin >> x >> y;
        a[i] = d[x]^d[y];
        dp[a[i]] ++;
    }
    for(int i=0;i<m;++i)
    {
        for(int j=0;j<=all1;++j)
        {
            if((j>>i)&1)    dp[j] = (dp[j] + dp[j^(1<<i)])%P;
        }
    }
    for(int i=1;i<=m;++i)
    {
        int ans = 0;
        for(int j=0;j<=all1;++j)
        {
            int cj = C(dp[all1^j],i);
            if(__builtin_popcount(j)&1)    ans = (ans-cj+P) % P;
            else    ans = (ans+cj)%P;
        }
        if(ans)
        {
            cout << i << ' ' << ans << '\n';
            return;
        }
    }
    cout << "-1\n";
}
```