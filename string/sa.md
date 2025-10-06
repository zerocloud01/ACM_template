## SA
> 将 $s_i$ 视作从 $i$ 开始的后缀，而不是单个字符

对字符串的后缀串进行排序。
因为 $\sum_i^n |s_i|$ 很大，所以只对编号排序。

- `rk[i]` 后缀 $s_i$ 的排名
- `sa[i]` 排名为 $i$ 的后缀

$rk_{sa_i} = i$

**LCP** —— 最长公共前缀
满足类似 **区间可加性**

设有排序过的字符串 $A$，对于任意 $k \in [i,j]$
$LCP(A_i,A_j) = LCP(LCP(A_i,A_k),LCP(A_k,A_j)) = \min (LCP(A_i,A_k),LCP(A_k,A_j))$

所以 $LCP(A_i,A_j) = \min_{x=i}^{j-1} LCP(A_x,A_{x+1}) $

**Height 数组**
$Height$ 数组为后缀 $i$ 与 后缀 $rk_{i-1}$ 的 $LCP$。
$Heigth_i = LCP(S_i,S_{sa[rk_{i}-1]})$

有 $Height$ 数组后，任意两个后缀的 $LCP$ 等同于区间最小值查询。

**实际使用常令：**$H[i] = Height[sa_i], (H[rk_i] = Height[i])$
所以 **$H[i]$ 表示 $rk_i$ 与 $rk_{i-1}$ 串的 $LCP$**

### 模板
这里用前缀倍增法，借助基数排序求后缀数组。
复杂度 $O(n \log n)$
```cpp
struct SA
{
	int L;
	vector<int> sa,rk,h,logk;
	vector<vector<int>> mn;
	SA(string& st)
	{
		L = st.size()-1;
		sa.resize(L+1), rk.resize(L+1), h.resize(L+1);
		build_sa(st), build_h(st);
	}
	void build_sa(const string &st)
	{
		int m = D, p = 0, len = max(m,L)+1;
		vector<int> cnt(len), lrk(len), lsa(len);
		for(int i=1;i<=L;++i)	++ cnt[rk[i] = (int)st[i]];
		for(int i=1;i<=m;++i)	cnt[i] += cnt[i-1];
		for(int i=L;i>=1;--i)	sa[cnt[rk[i]] --] = i;
		for(int w=1;p!=L;w<<=1,m=p)
		{
			int idx = 0;
			for(int i=L-w+1;i<=L;++i)	lsa[++ idx] = i;
			for(int i=1;i<=L;++i)
				if(sa[i] > w)	lsa[++ idx] = sa[i] - w;
			fill(cnt.begin(),cnt.end(),0);
			for(int i=1;i<=L;++i)	++ cnt[rk[i]];
			for(int i=1;i<=m;++i)	cnt[i] += cnt[i-1];
			for(int i=L;i>=1;--i)	
				sa[cnt[rk[lsa[i]]] --] = lsa[i];
			p = 0;
			for(int i=1;i<=L;++i)	lrk[i] = rk[i];
			for(int i=1;i<=L;++i)
			{
				if(lrk[sa[i]] == lrk[sa[i-1]] && 
				   lrk[sa[i]+w] == lrk[sa[i-1]+w])	rk[sa[i]] = p;
				else	rk[sa[i]] = ++ p;
			}
		}
	}
	void build_h(const string &st)
	{
		sa[0] = rk[0] = 0;
		for(int i=1,k=0;i<=L;++i)
		{
			if(k)	k --;
			while(st[i+k] == st[sa[rk[i]-1]+k])	++ k;
			h[rk[i]] = k;
		}
		logk.resize(L+1);
		logk[1] = 0;
		for(int i=2;i<=L;++i)	logk[i] = logk[i/2]+1;
		int k = logk[L]+1;
		mn.resize(k,vector<int>(L+1));
		for(int i=2;i<=L;++i)	mn[0][i] = h[i];
		for(int i=1;i<k;++i)
		{
			for(int j=2;j+(1<<i)-1<=L;++j)
			{
				mn[i][j] = min(mn[i-1][j],mn[i-1][j+(1<<(i-1))]);
			}
		}
	}
	int query_min(int l,int r)
	{
		int k = logk[r-l+1];
		return min(mn[k][l],mn[k][r-(1<<k)+1]);
	}
	int lcp(int i,int j)
	{
		if(i == j)	return L-i+1;
		int rki = rk[i], rkj = rk[j];
		if(rki > rkj)	swap(rki,rkj);
		return query_min(rki+1,rkj);
	}
};
```

### 应用

#### 本质不同子串
对于每个后缀，其能提供自身前缀个数的子串。
但是如果和相邻（下标）后缀串 LCP 不为 $0$，则他可以提供的这部分和上一个串的贡献重复了，需要被删去。

$ans = \sum_i^n len_i - h_i$

```cpp
for(int i=1;i<=sa.L;++i) ans += sa.L-sa.sa[i]+1 - sa.h[i];
```
#### 最长公共子串
##### 双串匹配
[最长公共子串](https://ac.nowcoder.com/acm/contest/37092/F)
先用特殊字符将两串链接

根据 $Height$ 的性质 $^{*}$，**最长 $LCP$ 必然出现在相邻串中**，那么只需要枚举下标，然后判断相邻后缀是否来自不同串
> $^{*}:$ $lcp$ 会取区间 $\min$ 那么相邻串必然 $lcp$ 最大
```cpp
for(int i=2;i<=sa.L;++i)
{
	if((sa.sa[i-1] <= Ls && sa.sa[i] > Ls+1) || (sa.sa[i-1] > Ls+1 && sa.sa[i] <= Ls))
		ans = max(ans,sa.h[i]);
}
```
#### 字符串匹配
运用 $lcp$。
设模式串 $s$，匹配串 $t$
将匹配串暴力拼接在模式串 $s$ 后，然后枚举 $1 \sim |s|$。
如果 $lcp(rk_i,rk_{t_1}) \ge |t|$，代表后缀 $s_i$ 的前缀存在 $t$。
也就是匹配成功。

##### 略过若干字符匹配
[P3763 [TJOI2017] DNA](https://www.luogu.com.cn/problem/P3763)

匹配串可以有三个被略过。
$\because |s| \le 10^5$ 可以暴力枚举所有起始位置。
每次匹配从 $s_x$ 和 $t_y$ 开始。（初始 $x = i, y = 1$）
> $lcp$ 指 $lcp(rk_x,rk_y)$
- 若是 $lcp \ge |t|$，匹配成功
- 若是 $lcp < |t|$，跳过当前字符，从 $x = x+lcp+1$ 和 $y = y+lcp+1$ 继续匹配。
- 重复上述步骤，直到用完所有略过次数。
```cpp
void func(void)
{
	string s0,s,st;
	cin >> s0 >> s;
	st = '_' + s0 + '#' + s;
	SA sa(st);
	int l1 = s0.size(), l2 = s.size(), ans = 0;
	for(int i=1;i<=l1-l2+1;++i)
	{
		int l = i, r = 1;
		for(int t=0;t<4;++t)
		{
			int lcp = sa.lcp(l,l1+1+r);
			if((r+lcp-1 == l2-1 && t != 3) || (r+lcp-1 >= l2))
			{
				ans ++;
				break;
			}
			l += lcp+1, r += lcp+1;
		}
	}
	cout << ans << '\n';
}
```