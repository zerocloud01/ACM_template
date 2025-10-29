https://codeforces.com/gym/105484/problem/C

## 树形dp
#### 24ICPC南京C 
给定一棵由 $n$ 个顶点组成的树，根节点为顶点 $1$。保证每个顶点的索引都小于其所有子节点的索引。该树的一个拓扑序是一个 $n$ 的排列 $p_1, p_2, \dots, p_n$，满足以下约束：对于所有 $1 \leq i < j \leq n$，顶点 $p_j$ 不是顶点 $p_i$ 的父节点。

对于每个 $1 \le i \le n$，计算满足 $p_i = i$ 的给定树的拓扑序的数量，结果对 $998\,244\,353$ 取模。

```cpp
int n;
int fact[N],invf[N];
int sz[N],mul[N],tp[N];
int dp[N][N];
vector<int> v[N];
 
int qpow(int a,int b)
{
	int z = 1;
	while(b)
	{
		if(b&1)	z = z*a%P;
		a = a*a%P;
		b >>= 1;
	}
	return z;
}
 
int inv(int x)
{
	return qpow(x,P-2);
}
 
int C(int x,int y)
{
	if(x < y)	return 0;
	return (fact[x]*invf[y]%P*invf[x-y]%P);
}
 
void dfs(int p)
{
	sz[p] = tp[p] = mul[p] = 1;
	for(auto &i : v[p])
	{
		dfs(i);
		sz[p] += sz[i];
		mul[p] = mul[p]*mul[i]%P;
	}
	mul[p] = mul[p]*sz[p]%P;
	tp[p] = fact[sz[p]]*inv(mul[p])%P;
}
 
void Dp(int p)
{
	for(auto &i : v[p])
	{
		int otp = mul[i]*inv(mul[p])%P*sz[p]%P*fact[sz[p]-sz[i]-1]%P;
		for(int j=1;j<=n;++j)
		{
			dp[i][j] = dp[p][j-1]*otp%P*C(n-j-sz[i]+1,sz[p]-sz[i]-1)%P;
			dp[i][j] = (dp[i][j] + dp[i][j-1])%P;
		}
		Dp(i);
	}
}
 
void func(void)
{
	cin >> n;
	for(int i=2;i<=n;++i)
	{
		int fa;cin >> fa;
		v[fa].push_back(i);
	}
	dp[1][1] = 1;
	dfs(1), Dp(1);
	for(int i=1;i<=n;++i)
	{
		dp[i][i] = dp[i][i]*tp[i]%P*C(n-i,sz[i]-1)%P;
		cout << dp[i][i] << ' ';
	}
	cout << '\n';
}
```

#### 24ICPC上海G
给定一个包含 $n$ 个顶点和 $n-1$ 条边的无向连通图，其中 $n$ 保证为奇数。你需要将所有 $n-1$ 条边划分为 $\frac{n-1}{2}$ 组，需满足以下约束条件：

- 每组恰好包含 2 条边  
- 同一组中的两条边共享一个公共顶点  

求满足条件的划分方案数，结果对 $998244353$ 取模。如果两种方案中存在两条边在一种方案中属于同一组，而在另一种方案中不属于同一组，则视为两种不同的方案。

**solution**
对于一个连接，$A - M - B$

对于一个子树，
- 如果节点数为奇数，则可以完成匹配，不需要依靠其他节点。
	> 指不需要子树外节点作为 $A B$，但是可以作为 $M$
- 否则有一个节点需要连接根节点的父节点，将父节点视作 $B$。

那么对于一个子树的根节点，此根节点的子树有两种情况
- 子树节点个数为偶数个，此子节点视作一个 $M$，然后将根节点视作 $B$ 完成一个连接。
- 子节点子树节点为奇数个，此子节点视作一个 $A$，然后将根节点视作 $M$。

对于第一种情况，不会影响答案方案。
第二种情况，需要安排这些将根节点视作 $M$ 的点的匹配。

- 这些节点若是有偶数个，则可以互相完成匹配
- 若是有奇数个，则有一个节点被孤立与父节点连接。但是实际方案数和节点 $+1$ 的情况相同。

那么我们可以得到递推式
- 在 $i$ 为奇数时，$F_i = F_{i-2}*(i-1)$
- 在 $i$ 为偶数时，$F_i = F_{i-1}$

既然子树的信息可以合并，那么我们设 $dp_i$ 表示以 $i$ 为根节点的子树的方案数。

$dp_i \leftarrow \prod dp_{son \ of \ i} \times {F_{cnt}}$，$cnt$ 表示将根节点视作 $M$ 的子树个数。

**注意开 `long long`**

**code**
```cpp
int n;
vector<int> v[N];
int dp[N],sz[N],pw[N];

void dfs(int p,int lp)
{
	sz[p] = dp[p] = 1;
	int cnt = 0;
	for(auto &i : v[p])
	{
		if(i == lp)	continue;
		dfs(i,p);
		sz[p] += sz[i];
		cnt += sz[i]&1;
		dp[p] = dp[p]*dp[i]%P;
	}
	cnt += cnt&1;
	dp[p] = dp[p]*pw[cnt]%P;
}

void func(void);

signed main(void)
{
	Start;
	int _ = 1;
	pw[0] = 1;
	for(int i=2;i<N;++i)	pw[i] = pw[i-2]*(i-1)%M;
	// cin >> _;
	while(_--)	func();
	return 0;
}

void func(void)
{
	cin >> n;
	for(int i=1;i<n;++i)
	{
		int x,y;	cin >> x >> y;
		v[x].push_back(y);
		v[y].push_back(x);
	}
	dfs(1,0);
	cout << dp[1] << '\n';
}
```

#### 21ICPC沈阳L
容斥 $+$ 树形dp

**solution**
计算使用了 $2n-1$ 条边的完美匹配，用不删边的完美匹配减去这些。

那么怎么统计使用被删边的匹配？这就要请出树形dp了。

$dp_{i,j,op}$ 表示以 $i$ 为根节点的子树，匹配了 $j$ 条被删边的方案数，$op$ 代表节点 $i$ 是否被匹配。

那么我们可以转移，设子树根节点为 $p$，此根节点子节点为 $i$
- 若是 $p$ 没有被选择 $dp_{p,j+k,0} \rightarrow dp_{p,j,0} \times dp_{i,k}$
- 若是被选择 $dp_{p,j+k,1} \rightarrow dp_{p,j,1} \times dp_{i,k}$
- 然后新增 $p-i$ 的匹配 $dp_{p,j+k+1,1} \rightarrow dp_{p,j,0} \times dp_{i,k,0}$

然后对于容斥，套容斥公式即可
**code**
```cpp
int n;
int fact[N],inv[N];
int dp[N][N][2],sz[N],f[N][2];
vector<int> v[N];

int qpow(int a,int b)
{
	int z = 1;
	while(b)
	{
		if(b&1)	z = z*a%P;
		a = a*a%P;
		b >>= 1;
	}
	return z;
}

int C(int x,int y)
{
	return fact[x]*inv[y]%P*inv[x-y]%P;
}

void dfs(int p,int lp)
{
	dp[p][0][0] = sz[p] = 1;
	for(auto &i : v[p])
	{
		if(i == lp)	continue;
		dfs(i,p);
		for(int j=0;j<=sz[p]/2;++j)
		{
			for(int k=0;k<=sz[i]/2;++k)
			{
				f[j+k][0] = (f[j+k][0] + dp[p][j][0]*((dp[i][k][0]+dp[i][k][1])%P)%P)%P;
				f[j+k][1] = (f[j+k][1] + dp[p][j][1]*((dp[i][k][0]+dp[i][k][1])%P)%P)%P;
				f[j+k+1][1] = (f[j+k+1][1] + dp[p][j][0]*dp[i][k][0]%P)%P;
			}
		}
		sz[p] += sz[i];
		for(int j=0;j<=sz[p]/2;++j)
		{
			dp[p][j][0] = f[j][0], dp[p][j][1] = f[j][1];
			f[j][0] = f[j][1] = 0;
		}
	}
}
```