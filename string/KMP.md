## KMP
### 模板
求 border + kmp查找

```cpp
// 从 2 开始
string st;// 模式串
string s;// 查找串

int nxt[N];
void get_next(string &st)// 求border
{
    for(int i=2;i<st.size();++i)
    {
        nxt[i] = nxt[i-1];
        while(nxt[i] && st[nxt[i]+1] != st[i])  nxt[i] = nxt[nxt[i]];
        nxt[i] += st[nxt[i]+1] == st[i];
    }
}

int kmp(int l,int r,string& s)// 求第一个匹配的位置
{
    for(int i=l,j=0;i<=r;++i)
    {
        while(j>0 && st[j+1] != s[i])   j = nxt[j];
        j += (st[j+1] == s[i]);
        if(j == m)  return i-j+1;
    }
}

int kmp(int l,int r,string& s)// 求匹配的个数
{
    int cnt = 0;
    for(int i=l,j=0;i<=r;++i)
    {
        while(j>0 && st[j+1] != s[i])   j = nxt[j];
        j += (st[j+1] == s[i]);
        if(j == m)
        {
            cnt ++;
            j = nxt[j];
        }
    }
}
```

### 题目
#### 串合并去重
需要合并 $a$ 和 $b$，并去除两者间公共部分。

只需要对 $b$ 新建border数组，然后用 $a$ 最后长度等于 $b$ 的部分进行匹配，匹配的最大长度及公共部分

对于 $n$ 个串首尾相接
```cpp
int n;
int nxt[N];
string s0,st;

void func(void)
{
	cin >> n;
	cin >> s0;
	for(int i=2;i<=n;++i)
	{
		cin >> st;
		st = '_' + st;
		for(int j=2;j<st.size();++j)
		{
			nxt[j] = nxt[j-1];
			while(nxt[j] && st[j] != st[nxt[j]+1])	nxt[j] = nxt[nxt[j]];
			nxt[j] += (st[j] == st[nxt[j]+1]);
		}
		int p = 0;
		int be = (s0.size() >= st.size()-1 ? s0.size()-st.size()+1 : 0);
		for(int j=be;j<s0.size();++j)
		{
			while(p>0 && st[p+1] != s0[j])	p = nxt[p];
			if(st[p+1] == s0[j])	p ++;
		}
		for(int j=p+1;j<st.size();++j)	s0 += st[j];
	}
	cout << s0 << '\n';
}
```

#### 反复删除子串
每次删除第一次出现的要求子串

存储各个位置匹配的最大长度，匹配满后跳跃到对应位置可直接从border中匹配
> `string.erase()` 貌似很慢，但是好像都不会tle，为防万一可以用栈存储。
> 后面一道acam的题面使用了栈存储 [子串删除问题](./acam.md/#子串删除问题)

```cpp
void func(void)
{
	string s,t;
	cin >> s >> t;
	int ls = s.size(), lt = t.size();
	t = '_' + t;
	vector<int> nxt(lt+1),p(ls+1);
	for(int i=2;i<=lt;++i)
	{
		nxt[i] = nxt[i-1];
		while(nxt[i] && t[i] != t[nxt[i]+1])	 nxt[i] = nxt[nxt[i]];
		nxt[i] += (t[i] == t[nxt[i]+1]);
	}
	for(int i=0,j=0;i<s.size();++i)
	{
		while(j>0 && t[j+1] != s[i])	j = nxt[j];
		if(t[j+1] == s[i])	j ++;
		p[i] = j;
		if(j == lt)
		{
			j = (i >= lt ? p[i-lt] : 0);
			i -= lt;
			s.erase(i+1,lt);
		}
		if(i >= 0)	p[i] = j;
	}
	cout << s << '\n';
}
```

#### 求最长真周期
根据性质：周期 $= |S| - border$
最长**真**周期则用最短 broder，用dfs传递最短border即可。
```cpp
> 这道题求最长真周期和
int n,nxt[N];
string st;
vector<int> v[N];
int ans;

void dfs(int p,int t)
{
	if(!t)	t = nxt[p];
	ans += (t ? p-t : 0);
	for(auto &i : v[p])
	{
		dfs(i,t);
	}
}

void func(void)
{
	cin >> n >> st;
	st = '_' + st;
	v[0].push_back(1);
	for(int i=2;i<=n;++i)
	{
		nxt[i] = nxt[i-1];
		while(nxt[i] && st[i] != st[nxt[i]+1])	nxt[i] = nxt[nxt[i]];
		nxt[i] += (st[i] == st[nxt[i]+1]);
		v[nxt[i]].push_back(i);
	}
	dfs(0,nxt[0]);
	cout << ans << '\n';
}
```

#### 求不重叠border数目
求各个前缀不重叠border数目，即 $\le S/2$ 的border数目

用dp存储各个串的border数目，每次将前方 $T \le S/2$ 的dp加入答案

```cpp
int n,ans;
string st;
int nxt[N],dp[N];

void func(void)
{
	cin >> st;
	n = st.size(),ans = 1;
	st = '_' + st;
	memset(dp,0,sizeof dp);
	for(int i=2;i<=n;++i)
	{
		nxt[i] = nxt[i-1];
		while(nxt[i] && st[i] != st[nxt[i]+1])	nxt[i] = nxt[nxt[i]];
		nxt[i] += (st[i] == st[nxt[i]+1]);
		if(nxt[i])	dp[i] = dp[nxt[i]] + 1;
		// cout << i << ' ' << dp[i] << '\n';
	}
	for(int i=n;i>=1;--i)
	{
		int p = nxt[i];
		vector<int> tmp;
		while(p*2 > i)
		{
			tmp.push_back(p);
			p = nxt[p];
		}
		for(auto &i : tmp)	nxt[i] = p;
		if(p)	ans = ans*(dp[p]+2)%M;
	}
	cout << ans << '\n';
}
```