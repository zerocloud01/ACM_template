## 字符串Hash
$1123455751, 1234567891, 1345678999, 1456789877, 1567890121, 1678901237, 1789012343, 1890123457, 1987654321$

- 自然溢出： 使用 `ULL` 保存Hash值，溢出 `ULL`，等同于 $\% 2^{64}$(很容易卡)

- 质数单模： 选取**一个**$10^9 \sim 10^{10}$ 的大质数，但是有 **广为人知** 的方法构造冲突。
	> 如果在int内更多，会更有优势 (在32位计算机上)

- **双模：** 进行多次不同质数的单模哈希，冲突概率为各次单模的概率乘积
	> 在不泄露模数的情况下，没有已知方法可以构造冲突

出于减少冲突，有且仅介绍双模Hash

##### 快速求子串 hash
$H(S) = (S_l \times Base^{r-l} + S_{l+1}+1 \times Base^{r-l-1} + \cdots + S_r)\% mod$

令 $F(i) = H(prefix[i])$

$F(l-1) = (S_1 \times Base^{l-2} + S_{2} \times Base^{l-3} + \cdots + S_{l-1}) \% mod$
$F(r) = (S_1 \times Base^{r-1} + S_{2} \times Base^{r-2} + \cdots + S_{r}) \% mod$

$\therefore H(S[l,r]) = F(r) - F(l-1) \times Base^{r-l+1}$

#### 回文串
对于回文串，正向Hash和反向Hash值是一样的

### 模板
```cpp
const int D = 26;
const PII mod = {1123455751,1987654321};

// 用数组存储，复杂度/log2
PII pw[N];// D^x
pw[0] = {1,1};
for(int i=1;i<N;++i)
{
	pw[i] = pw[i-1];
	pw[i].X = (pw[i].X*D)%mod.X;
	pw[i].Y = (pw[i].Y*D)%mod.Y;
}

void init(string &st,vector<PII>& s)
{
	int L = st.size()-1;
	for(int i=1;i<=L;++i)
	{
		s[i].X = (s[i-1].X*D%mod.X+st[i]-'A')%mod.X;
		s[i].Y = (s[i-1].Y*D%mod.Y+st[i]-'A')%mod.Y;
	}
}

PII h(int l,int r,vector<PII> &s)
{
	PII res;
	res.X = (s[r].X - s[l-1].X*pw[r-l+1].X%mod.X+mod.X)%mod.X;
	res.Y = (s[r].Y - s[l-1].Y*pw[r-l+1].Y%mod.Y+mod.Y)%mod.Y;
	return res;
}
```

### 应用
#### 字符串匹配
**Hash 有二分性**
枚举模式串的起始位置，然后二分结束位置。`check` 检测模式子串与相同长度模式串是否相等。

