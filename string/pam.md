## 回文自动机
$Palindrome Automaton$ 回文自动机，回文树。

一种能识别一个串所有回文串的数据结构，结构类似acam。

- **节点：** 至多 $n$ 个，每个节点表示一个回文串，$S(u)$ 表示节点 $u$ 代表的回文串，那么$len_u = |S(u)|$
- **后继边：** 每个后继边表示一个字母，$tran(u,ch) = v$ 表示 $u$ 节点的后继边 $ch$ 指向 $v$，那么 $S(v) = chS(v)ch$，$len_v = len_u + 2$
- **失配边：** 每个节点都有一个失配边，$fail_u = v$ 表示 $u$ 节点是失配边都指向了 $v$ 节点。则有 $S_v$ 是 $S_u$ 的最大border，即最长会问后缀。

### PAM的构造
实际是构造最长回文后缀。方法是枚举前一个位置的回文后缀，即fail链

PAM的**特殊之处**在于：对于奇回文串和偶回文串有**两个根节点**。
因为 $Len = 2$ 为偶根后继，$Len = 1$ 为奇根后继，所以偶根设 $Len = 0$，奇根设 $Len = -1$。
方便起见，可以令偶根的失配边指向奇根，奇根的指向偶根

$Last$ 指针表示最后一个访问的点是谁。

每次加入一个点后，访问 $last$ 的fail链，遇到满足回文则连接到对应节点上，并且$L = x+2$。
而新节点的fail链则再爬一次 $last$ 节点的fail链，用类似方法求解。

### 模板1
模仿 `acam` 模板的格式，结构更相似些。
```cpp
int idx,lst;// 当前节点，最后指向节点
int nxt[N][26],len[N],fail[N];// 子节点指针，回文长度，失配指针
string st;
// 求 fail
int get_fail(int k,int x)
{
	while(st[k-len[x]-1] != st[k])	x = fail[x];
	return x;
}

void build_pam(void)
{
    // 保证 0 - 1 互相指向，且新节点从 2 开始，因为 01 各咋占一个
	len[0] = 0, fail[0] = 1;
	len[1] = -1, fail[1] = 0;
	idx = 1;
	for(int i=1;i<st.size();++i)
	{
		int p = get_fail(i,lst), c = st[i] - 'a';
		if(!nxt[p][c])
		{
			len[++ idx] = len[p] + 2;
			fail[idx] = nxt[get_fail(i,fail[p])][c];
			nxt[p][c] = idx;
		}
		lst = nxt[p][c];
	}
}
```

### 模板2
传统 `pam` 模板，`new_node()` 和 `init()` 更适合多测题。
```cpp
int lst,idx;
int nxt[N][D],fail[N],len[N];
string st;

int new_node(int L)
{
	len[++ idx] = L;
	fail[idx] = 0;
	memset(nxt[idx],0,sizeof nxt[idx]);
	return idx;
}

int get_fail(int x)
{
	while(st[st.size()-2-len[x]] != st.back())	x = fail[x];
	return x;
}

void init(void)
{
	idx = -1, lst = 0;
	st = '_';
	new_node(0), new_node(-1);
	fail[0] = 1, fail[1] = 0;
}

void insert(char c)
{
	st += c;
	int p = get_fail(lst), t = c-'a';
	if(!nxt[p][t])
	{
		int x = new_node(len[p]+2);
		fail[x] = nxt[get_fail(fail[p])][t];
		nxt[p][t] = x;
	}
	lst = nxt[p][t];
}
```

### 题目
#### fail树运用
[P4287 [SHOI2011] 双倍回文](https://www.luogu.com.cn/problem/P4287)
回文树节点的父节点，代表该节点 $Len - 2$ 的回文串，即删除两头元素的串。
而 $fail$ 树上的节点的父节点，是作为当前串后缀的回文串。

那么这道题只需要爬 $fail$ 树，然后找该节点的祖先中是否存在长度**恰好**为此节点长度一半的元素。暴力容易 $TLE$，故用树上倍增。

```cpp
int n,idx,lst,ans;
int nxt[N][D],fa[N][D],fail[N],len[N];
string st;
vector<int> v[N];

int new_node(int L)
{
	len[++ idx] = L;
	fail[idx] = 0;
	memset(nxt[idx],0,sizeof nxt[idx]);
	return idx;
}

int get_fail(int x)
{
	while(st[st.size()-2-len[x]] != st.back())	x = fail[x];
	return x;
}

void init(void)
{
	idx = -1, lst = 0;
	st = '_';
	new_node(0), new_node(-1);
	fail[0] = 1, fail[1] = 0;
}

void insert(char c)
{
	st += c;
	int p = get_fail(lst), t = c-'a';
	if(!nxt[p][t])
	{
		int x = new_node(len[p]+2);
		fail[x] = nxt[get_fail(fail[p])][t];
		v[fail[x]].push_back(x);
		nxt[p][t] = x;
	}
	lst = nxt[p][t];
}
// 构造fail树的倍增
void dfs(int p,int lp)
{
	fa[p][0] = lp;
	for(int i=1;i<D;++i)	fa[p][i] = fa[fa[p][i-1]][i-1];
	for(auto &i : v[p])	dfs(i,p);
}

void func(void)
{
	int n;	cin >> n;
	string s0;	cin >> s0;
	init();
	for(int i=0;i<n;++i)	insert(s0[i]);
	dfs(0,0);// 根节点不止一个，所以跑两次
	dfs(1,0);
	for(int i=0;i<=idx;++i)
	{
		if(len[i]%4 == 0 && len[i])
		{
			int x = i;
			for(int j=D-1;j>=0;--j)
			{
				if(len[fa[x][j]] > len[i]/2)	x = fa[x][j];
			}
			if(len[fa[x][0]]*2 == len[i])	ans = max(ans,len[i]);
		}
	}
	cout << ans << '\n';
}
```

#### 回文串出现次数
[P1659 [国家集训队] 拉拉队排练](https://www.luogu.com.cn/problem/P1659)
这题只需要统计长度为奇数的个数，用 $Manacher$ 或许更方便。但是用 $Pam$ 也有不同收获。

$Pam$ 新加入一个字符，不仅该节点代表的串 $cnt + 1$，**而且 $fail$ 链上的串个数均要 $+1$**。

```cpp
int n,k;
int idx,lst;
int nxt[N][D],fail[N],len[N],cnt[N],res[N];
string st;

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

int new_node(int L)
{
	len[++ idx] = L;
	fail[idx] = 0;
	memset(nxt[idx],0,sizeof nxt[idx]);
	return idx;
}

int get_fail(int x)
{
	while(st[st.size()-2-len[x]] != st.back())	x = fail[x];
	return x;
}

void init(void)
{
	idx = -1, lst = 0;
	st = '_';
	new_node(0), new_node(-1);
	fail[0] = 1, fail[1] = 0;
}

void insert(char c)
{
	st += c;
	int p = get_fail(lst), t = c-'a';
	if(!nxt[p][t])
	{
		int x = new_node(len[p]+2);
		fail[x] = nxt[get_fail(fail[p])][t];
		nxt[p][t] = x;
	}
	lst = nxt[p][t];
	cnt[lst] ++;
}

void func(void)
{
	cin >> n >> k;
	string s0;	cin >> s0;
	init();
	for(int i=0;i<n;++i)	insert(s0[i]);
	n -= !(n&1);
	int ans = 1;
	for(int i=idx;i>=0;--i)	cnt[fail[i]] += cnt[i];
	for(int i=2;i<=idx;++i)
	{
		if(len[i]&1)	res[len[i]] += cnt[i];
	}
	for(int i=n;i>=1;i-=2)
	{
		if(res[i] <= k)
		{
			ans = ans*qpow(i,res[i])%P;
			k -= res[i];
		}
		else
		{
			ans = ans*qpow(i,k)%P;
			k = 0;
			break;
		}
	}
	cout << (k ? -1 : ans) << '\n';
}
```