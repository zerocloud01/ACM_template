## ac自动机
### 模板
trie树+fail（失配）指针
每个串保存trie树中最长相同前缀，这样失配的时候可以直接跳转匹配。

```cpp
int n,idx;
int nxt[N][26],fail[N];
bitset<N> ext;
// trie
void insert(string &st,int id)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i] - 'a';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
    ext[p] = id;
}
// acam
void build_acam(void)
{
	queue<int> q;
	for(int i=0;i<D;++i)
		if(nxt[0][i])	q.push(nxt[0][i]);
	while(q.size())
	{
		int p = q.front();	q.pop();
		for(int i=0;i<26;++i)
		{
			if(!nxt[p][i]) nxt[p][i] = nxt[fail[p]][i];
            else
            {
                int ps = nxt[p][i];	q.push(ps);
                fail[ps] = nxt[fail[p]][i];
            }
			
		}
	}
}

void query_acam(string &st)
{
	for(int i=0,p=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		// 因为trie树的节点被重构了，所以可以直接跑
		p = nxt[p][c];
		// do...
	}
}
```

### 题目
#### 子串删除问题
给定一个字符串 $S$ 和一个字典，反复删除 $S$ 在字典出现的第一个模式串

和前面那道kmp一样，只不过这题需要删除所有模式串的结果。

解法和那题差不多，只不过需要存储匹配的自动机节点，而非border串长度（其实本质是相同的）
这里没有用erase，而是用了栈，刚好两道题可以互相对应 [反复删除子串](./KMP.md/#反复删除子串)
```cpp
string s0;
int n,idx,tmp[N];
int nxt[N][26],fail[N];
int ext[N];

void insert(string &st,int L)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
	ext[p] = L;
}

void build_acam(void)
{
	queue<int> q;
	q.push(0);
	while(q.size())
	{
		int p = q.front();	q.pop();
		for(int i=0;i<26;++i)
		{
			if(!nxt[p][i])	nxt[p][i] = nxt[fail[p]][i];
			else
			{
				int ps = nxt[p][i];
				fail[ps] = fail[p];
				while(fail[ps] && !nxt[fail[ps]][i])	fail[ps] = fail[fail[ps]];
				if(p && nxt[fail[ps]][i])	fail[ps] = nxt[fail[ps]][i];
				q.push(ps);
			}
			
		}
	}
}

void func(void)
{
	cin >> s0 >> n;
	string st;
	for(int i=1;i<=n;++i)
	{
		cin >> st;
		insert(st,st.size());
	}
	vector<pair<char,int>> ans;
	build_acam();
	int p = 0;
	for(int i=0;i<s0.size();++i)
	{
		int c = s0[i]-'a';
		p = nxt[p][c];
		
		ans.push_back({s0[i],0});
		if(ext[p])
		{
			for(int j=ext[p];j>0;--j)	ans.pop_back();
			p = (ans.size() ? (ans.back()).Y : 0);
		}
		if(ans.size())	ans.back().Y = p;
	}
	for(auto &i : ans)	cout << i.X;
}
```
#### 模式串出现次数
统计模式串在字典中的出现次数

求fail树上该节点的子树大小，其实也和kmp求出现次数一样。

```cpp
int n,idx;
int nxt[N][26],fail[N];
int cnt[N],mp[N];
vector<int> ft[N];

void insert(string &st,int id)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
		cnt[p] ++;
	}
	mp[id] = p;
}

void build_acam(void)
{
	queue<int> q;	q.push(0);
	while(q.size())
	{
		int lp = q.front();	q.pop();
		for(int i=0;i<26;++i)
		{
			if(!nxt[lp][i])	nxt[lp][i] = nxt[fail[lp]][i];
			else
			{
				int p = nxt[lp][i];
				fail[p] = fail[lp];
				while(fail[p] && !nxt[fail[p]][i])	fail[p] = fail[fail[p]];
				if(lp && nxt[fail[p]][i])	fail[p] = nxt[fail[p]][i];
				ft[fail[p]].push_back(p);
				q.push(p);
			}
		}
	}
}

void dfs(int p)
{
	for(auto &i : ft[p])
	{
		dfs(i);
		cnt[p] += cnt[i];
	}
}

void func(void)
{
	cin >> n;
	string st;
	for(int i=1;i<=n;++i)
	{
		cin >> st;
		insert(st,i);
	}
	build_acam();
	dfs(0);
	for(int i=1;i<=n;++i)	cout << cnt[mp[i]] << '\n';
}
```

#### acam dp
##### P3041 [USACO12JAN] Video Game G
Bessie 在玩一款游戏，该游戏只有三个技能键 `A`，`B`，`C` 可用，但这些键可用形成 $n$ 种特定的组合技。第 $i$ 个组合技用一个字符串 $s_i$ 表示。

Bessie 会输入一个长度为 $k$ 的字符串 $t$，而一个组合技每在 $t$ 中出现一次，Bessie 就会获得一分。$s_i$ 在 $t$ 中出现一次指的是 $s_i$ 是 $t$ 从某个位置起的连续子串。如果 $s_i$ 从 $t$ 的多个位置起都是连续子串，那么算作 $s_i$ 出现了多次。

若 Bessie 输入了恰好 $k$ 个字符，则她最多能获得多少分？

**solution**
`dp[i][j]` 表示长度为 $i$ 的以 acam节点$j$ 为结尾字符串最大 $dp$ 值

那么dp每次就可以从acam树上的父节点转移到子节点
```cpp
int n,m,idx;
int nxt[N][3],fail[N],val[N];
int dp[M][M];

void insert(string &st)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'A';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
	val[p] ++;
}

void build_acam(void)
{
	queue<int> q;
	for(int i=0;i<3;++i)
	{
		if(nxt[0][i])	q.push(nxt[0][i]);
	}
	while(q.size())
	{
		int lp = q.front();	q.pop();
		for(int i=0;i<3;++i)
		{
			if(!nxt[lp][i])	nxt[lp][i] = nxt[fail[lp]][i];
			else
			{
				int p = nxt[lp][i];
				fail[p] = nxt[fail[lp]][i];
				q.push(p);
				val[p] += val[fail[p]];
			}
		}
	}
}

void func(void)
{
	cin >> n >> m;
	for(int i=0;i<n;++i)
	{
		string st;	cin >> st;
		insert(st);
	}
	build_acam();
	int ans = 0;
	memset(dp,0xaf,sizeof dp); // -inf
	dp[0][0] = 0;
	for(int i=1;i<=m;++i)
	{
		for(int j=0;j<=idx;++j)
		{
			for(int k=0;k<3;++k)	dp[i][nxt[j][k]] = max(dp[i][nxt[j][k]],dp[i-1][j]+val[nxt[j][k]]);
		}
	}
	for(int i=0;i<=idx;++i)	ans = max(ans,dp[m][i]);
	cout << ans << '\n';
}
```

##### P4052 [JSOI2007] 文本生成器
JSOI 交给队员 ZYX 一个任务，编制一个称之为“文本生成器”的电脑软件：该软件的使用者是一些低幼人群，他们现在使用的是 GW 文本生成器 v6 版。

该软件可以随机生成一些文章——总是生成一篇长度固定且完全随机的文章。 也就是说，生成的文章中每个字符都是完全随机的。如果一篇文章中至少包含使用者们了解的一个单词，那么我们说这篇文章是可读的（我们称文章 $s$ 包含单词 $t$，当且仅当单词 $t$ 是文章 $s$ 的子串）。但是，即使按照这样的标准，使用者现在使用的 GW 文本生成器 v6 版所生成的文章也是几乎完全不可读的。ZYX 需要指出 GW 文本生成器 v6 生成的所有文本中，可读文本的数量，以便能够成功获得 v7 更新版。你能帮助他吗？

和上一题不同，求的是子串存在模式串的串总数
**solution**
求存在不方便，所以求不存在
`dp[i][j]` 表示长度为 $i$ 的以 acam节点$j$ 为结尾的字符串不存在字典串总数

最后再 $sum-dp$ 即可
```cpp
int n,m,idx;
int nxt[N][D],fail[N];
int dp[110][N];
bitset<N> ext;

void insert(string &st)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'A';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
	ext[p] = true;
}

void build_acam(void)
{
	queue<int> q;
	for(int i=0;i<26;++i)
		if(nxt[0][i])	q.push(nxt[0][i]);
	while(q.size())
	{
		int p = q.front();	q.pop();
		for(int i=0;i<D;++i)
		{
			if(!nxt[p][i])	nxt[p][i] = nxt[fail[p]][i];
			else
			{
				int ps = nxt[p][i];	q.push(ps);
				fail[ps] = nxt[fail[p]][i];
				ext[ps] = ext[fail[ps]];
			}
		}
	}
}

void func(void)
{
	cin >> n >> m;
	for(int i=0;i<n;++i)
	{
		string st;	cin >> st;
		insert(st);
	}
	build_acam();
	dp[0][0] = 1;
	for(int i=1;i<=m;++i)
	{
		for(int j=0;j<=idx;++j)
		{
			for(int k=0;k<D;++k)
			{
				if(!ext[nxt[j][k]])	dp[i][nxt[j][k]] = (dp[i][nxt[j][k]]+dp[i-1][j])%M;
			}
		}
	}
	int ans = 1;
	for(int i=1;i<=m;++i)	ans = (ans*26)%M;
	for(int i=0;i<=idx;++i)	ans = (ans-dp[m][i]+M)%M;
	cout << ans << '\n';
}
```

#### 模式串互相匹配
求模式串在模式串的出现次数

等同于求有多少个属于Y的节点的fail指针直接或间接指向X的结束位置

那么我们对fail求dfn，然后跑**trie树**，离线询问并用树状数组维护出现次数
> 因为是模式串在模式串，所以只能跑原始trie树
```cpp
int m,idx,tot;
int dfn[N],sz[N],t[N];
int nxt[N][D],trie[N][D],fail[N],ans[N],mp[N],fa[N];
vector<int> ft[N];
vector<PII> eq[N];
string st,s0;

void put(int p,int z)
{
	for(int i=p;i<=tot;i+=i&-i)	t[i] += z;
}

int query(int l,int r)
{
	int res = 0;
	for(int i=r;i>=1;i-=i&-i)	res += t[i];
	for(int i=l-1;i>=1;i-=i&-i)	res -= t[i];
	return res;
}

void dfs(int p)
{
	dfn[p] = ++ tot;
	sz[p] = 1;
	for(auto &i : ft[p])
	{
		dfs(i);
		sz[p] += sz[i];
	}
}

void build_acam(void)
{
	queue<int> q;
	for(int i=0;i<D;++i)
	{
		if(nxt[0][i])
		{
			q.push(nxt[0][i]);
			ft[0].push_back(nxt[0][i]);
		}
	}
	while(q.size())
	{
		int p = q.front();	q.pop();
		for(int i=0;i<D;++i)
		{
			if(!nxt[p][i])		nxt[p][i] = nxt[fail[p]][i];
			else
			{
				int ps = nxt[p][i];	q.push(ps);
				fail[ps] = nxt[fail[p]][i];
				ft[fail[ps]].push_back(ps);
			}
		}
	}
	dfs(0);
}

void dfs_trie(int p)
{
	put(dfn[p],1);
	for(auto &[x,id] : eq[p])	ans[id] = query(dfn[x],dfn[x]+sz[x]-1);
	for(int i=0;i<26;++i)
	{
		if(trie[p][i])	dfs_trie(trie[p][i]);
	}
	put(dfn[p],-1);
}

signed main(void)
{
	Start;
	string s0;	cin >> s0;
	int cnt = 0,p=0;
	for(auto &i : s0)
	{
		if(i == 'B')
		{
			if(st.size())	st.erase(st.end()-1);
			p = fa[p];
		}
		else if(i == 'P')
		{
			for(auto &j : st)
			{
				int c = j-'a';
				if(!nxt[p][c])	nxt[p][c] = ++ idx;
				trie[p][c] = nxt[p][c];
				fa[nxt[p][c]] = p;
				p = nxt[p][c];
			}
			mp[++ cnt] = p;
			st.clear();
		}
		else	st += i;
	}
	cin >> m;
	build_acam();
	for(int i=1;i<=m;++i)
	{
		int x,y;	cin >> x >> y;
		eq[mp[y]].push_back({mp[x],i});
	}
	dfs_trie(0);
	for(int i=1;i<=m;++i)	cout << ans[i] << '\n';
	return 0;
}
```