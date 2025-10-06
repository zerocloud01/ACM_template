## SAM
后缀自动机

需要额外维护一个**后缀链接树**，`link[]`。

`link` 和 `nxt` 使用相同节点。

- `nxt` 从根节点出发的任意路径，可以表示一个子串。
- `link` 上的每个节点代表一个 $endpos$ 等价类。代表后缀位置相同的子串集合。

插入操作 `extend` 复杂度均摊 $O(1)$


### 模板
数组实现
```cpp
int nxt[N][D],lk[N],len[N];
int rt = 1,lst = 1,idx = 1;

void extend(char c)
{
	int p = lst, u = ++ idx, t = c-'a';
	lst = u, len[u] = len[p]+1;
	while(p && (!nxt[p][t]))
	{
		nxt[p][t] = u;
		p = lk[p];
	}
	if(!p)
	{
		lk[u] = rt;
		return;
	}
	int np = nxt[p][t];
	if(len[p]+1 == len[np])	lk[u] = np;
	else
	{
		int tp = ++ idx;
		memcpy(nxt[tp],nxt[np],sizeof(nxt[np]));
		len[tp] = len[p]+1, lk[tp] = lk[np];
		lk[np] = lk[u] = tp;
		while(p && nxt[p][t] == np)
		{
			nxt[p][t] = tp;
			p = lk[p];
		}
	}
}
```
封装
```cpp
struct SAM
{
	struct state
	{
		int link,len;
		array<int,D> nxt;
        // map<int,int> nxt;
        // 用map实现复杂度也不高
	};
	int rt,lst;
	vector<state> sam;
	SAM()
	{
		rt = lst = 1;
		sam.resize(2);
	}
	int new_node(void)
	{
		sam.emplace_back();
		return sam.size()-1;
	}
	void extend(char c)
	{
		int p = lst, u = new_node(), t = c-'a';
		lst = u, sam[u].len = sam[p].len+1;
        // while(p && (!sam[p].nxt.count(t)))
		while(p && (!sam[p].nxt[t]))
		{
			sam[p].nxt[t] = u;
			p = sam[p].link;
		}
		if(!p)
		{
			sam[u].link = rt;
			return;
		}
		int np = sam[p].nxt[t];
		if(sam[p].len+1 == sam[np].len)	sam[u].link = np;
		else
		{
			int tp = new_node();
			sam[tp] = sam[np], sam[tp].len = sam[p].len+1;
			sam[np].link = sam[u].link = tp;
			while(p && sam[p].nxt[t] == np)
			{
				sam[p].nxt[t] = tp;
				p = sam[p].link;
			}
		}
	}
	int link(int p)
	{
		return sam[p].link;
	}
	int len(int p)
	{
		return sam[p].len;
	}
	int L()
	{
		return sam.size()-1;
	}
};
```
### 应用
#### 本质不同子串
https://ac.nowcoder.com/acm/contest/37092/H
对于 link 树，每个节点存储的 $endpos$ 代表一个本质不同子串。

那么每个节点的贡献就是 $len_{\max} - len_{\min} = len_p - len_{link[p]}$

##### 在线维护
[P4070 [SDOI2016] 生成魔咒](https://www.luogu.com.cn/problem/P4070)
每次 `extend` 时统计新增节点的贡献即可，
**注意：** 分裂的节点不产生共享，因为之前已经计算过

#### 子串出现次数
- [CF802I](https://codeforces.com/problemset/problem/802/I)	求出现次数的模板
- [luogu P3084](https://www.luogu.com.cn/problem/P3804)	出现次数 $times$ 长度
- [SP8222](https://www.luogu.com.cn/problem/SP8222) 每个 link 节点代表的子串出现次数相同，那么对包含的 $[len_{\min}, len_{\max}]$ 做最值 $RMQ$ 即可。其实就是最值线段树。

**子串出现次数 $=$ link 树上对应节点的子树大小。**

但是只有**每次新插入的节点可以有贡献**，而复制的节点不能
> 很明显一个子串最多出现 $n$ 次，但是节点却可以有 $2n$ 个

所以我们赋值需要再 `extend` 中每次新建节点时做，而不是在 `dfs` 做

因为遇到大量模板题，所以贴一个模板代码
```cpp
vector<int> v[N];
int cnt[N],n;
int nxt[N][D],fa[N],len[N];
int rt=1,lst=1,idx=1;
int t[N<<2],lz[N<<2];

void extend(char c)
{
	int p = lst, u = ++ idx, t = c-'a';
	lst = u, len[u] = len[p]+1;
	cnt[u] = 1;
	while(p && !nxt[p][t])
	{
		nxt[p][t] = u;
		p = fa[p];
	}
	if(!p)
	{
		fa[u] = rt;
		return;
	}
	int np = nxt[p][t];
	if(len[p]+1 == len[np])	fa[u] = np;
	else
	{
		int tp = ++ idx;
		memcpy(nxt[tp],nxt[np],sizeof(nxt[np]));
		len[tp] = len[p]+1, fa[tp] = fa[np];
		fa[np] = fa[u] = tp;
		while(p && nxt[p][t] == np)
		{
			nxt[p][t] = tp;
			p = fa[p];
		}
	}
}

void dfs(int p,int lp)
{
	for(auto &i : v[p])
	{
		dfs(i,p);
		cnt[p] += cnt[i];
	}
}
```
#### 字符串匹配
> 感觉远不如 $sa$ 好用

和 $sa$ 的匹配方法差不多，不过 SAM 是看最长公共后缀。

设模式串 $s$，匹配串 $t$
用~~伪~~广义后缀自动机，将模式串和匹配串拼起来。
`extend` 的同时记录每次加入字符对应的节点。
因为 link 树上两个节点的 $lca$ 代表两个串的公共后缀，那么只要后缀 $\ge |t|$，代表 $s$ 中存在该子串。

##### 略过若干字符匹配
和 SA 的写法基本一样，都是匹配 $4$ 次。
但是不知道是 $lca$ 的问题还是什么，一直 $TLE$。

所以压缩了字符集
```cpp
#include<bits/stdc++.h>
#define Start cin.tie(0), cout.tie(0), ios::sync_with_stdio(false)
#define X first
#define Y second
// #define int long long
using namespace std;
using PII = pair<int,int>;
using u64 = unsigned long long;
using i64 = long long;
using i128 = __int128;

const double eps = 1e-6;
const i64 inf = 1e15;
const int P = 998244353;
const int M = 1000000007;
const int N = 4e5 + 10;
const int D = 20;

string s0,s,st;
int fa[N][D],dep[N];
vector<int> v[N];
int mp[128];

struct SAM
{
	struct state
	{
		int link,len;
		array<int,5> nxt;
        // map<int,int> nxt;
        // 用map实现复杂度也不高
	};
	int rt,lst;
	vector<state> sam;
	vector<int> ed;
	SAM(string &st)
	{
		rt = lst = 1;
		sam.resize(2);
		ed.resize(st.size());
		for(int i=1;i<st.size();++i)	extend(st[i],i);
	}
	int new_node(void)
	{
		sam.emplace_back();
		return sam.size()-1;
	}
	void extend(char c,int i)
	{
		int p = lst, u = new_node(), t = mp[c];
		lst = u, sam[u].len = sam[p].len+1;
		ed[i] = lst;
        // while(p && (!sam[p].nxt.count(t)))
		while(p && (!sam[p].nxt[t]))
		{
			sam[p].nxt[t] = u;
			p = sam[p].link;
		}
		if(!p)
		{
			sam[u].link = rt;
			return;
		}
		int np = sam[p].nxt[t];
		if(sam[p].len+1 == sam[np].len)	sam[u].link = np;
		else
		{
			int tp = new_node();
			sam[tp] = sam[np], sam[tp].len = sam[p].len+1;
			sam[np].link = sam[u].link = tp;
			while(p && sam[p].nxt[t] == np)
			{
				sam[p].nxt[t] = tp;
				p = sam[p].link;
			}
		}
	}
	int link(int p)
	{
		return sam[p].link;
	}
	int len(int p)
	{
		return sam[p].len;
	}
	int L()
	{
		return sam.size()-1;
	}
};

void dfs(int p,int lp)
{
	fa[p][0] = lp;
	dep[p] = dep[lp]+1;
	for(int i=1;i<D;++i)	fa[p][i] = fa[fa[p][i-1]][i-1];
	for(auto &i : v[p])	dfs(i,p);
}

int lca(int x,int y)
{
	if(dep[x] < dep[y])	swap(x,y);
	for(int i=D-1;i>=0;--i)
	{
		if(dep[fa[x][i]] >= dep[y])	x = fa[x][i];
	}
	if(x == y)	return x;
	for(int i=D-1;i>=0;--i)
	{
		if(fa[x][i] != fa[y][i])	x = fa[x][i], y = fa[y][i];
	}
	return fa[x][0];
}

void func(void);

signed main(void)
{
	Start;
	int _ = 1;
	mp['A'] = 0, mp['T'] = 1, mp['C'] = 2, mp['G'] = 3, mp['#'] = 4;
	cin >> _;
	while(_--)	func();
	return 0;
}

void func(void)
{
	
	cin >> s0 >> s;
	st = '_' + s0 + '#' + s;
	SAM sam(st);
	for(int i=0;i<=sam.L();++i)	v[i].clear();
	for(int i=1;i<=sam.L();++i)	v[sam.link(i)].push_back(i);
	dfs(1,1);
	int l1 = s0.size(), l2 = s.size();
	int ans = 0;
	for(int i=l2;i<=l1;++i)
	{
		int l = i, r = l2;
		for(int t=0;t<4;++t)
		{
			
			int lcs = sam.len(lca(sam.ed[l],sam.ed[r+l1+1]));
			if((lcs == r-1 && t != 3) || lcs >= r)
			{
				ans ++;
				break;
			}
			l -= lcs+1, r -= lcs+1;
		}
	}
	cout << ans << '\n';
}
```

#### 最长公共子串
##### 双串匹配
[最长公共子串](https://ac.nowcoder.com/acm/contest/37092/F)
[LCS - Longest Common Substring](https://www.spoj.com/problems/LCS/)
先用 ~~伪~~GSAM 将两个串拼起来，然后求直接求sam。

开始用dfs序处理了 link 树，如果一个节点子树内同时出现了双串节点，代表其可以作为公共子串，那么枚举子树求最值即可。但是因为牛客 $\sum s \le 10^6 \rightarrow \sum node \approx 2\times 10^6$，sam $+$ 邻接表直接 $MLE$ 了。

就借用了 SA 那边的性质，最优解必然是相邻串的。那么只需要求 $\max len(link_p)$

**注意在复制时，截止位置也要复制**。