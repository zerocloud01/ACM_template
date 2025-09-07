## 字符串Hash
### 概念
哈希：一种单射函数，可以将**万物**映射为一个整数值。
**字符串哈希：** 将一个字符串映射为一个整数值的方法，<u>通常用来比较两个字符串是否相等</u>

**性质：** 
- **必要性：** 若字符串 $S = T$，则 $H(S) = H(T)$
- **非**充分性：若 $H(S) = H(T)$，**不一定** $S = T$ (可以实现，但不要求)

**Hash检测：** 通过检测 $H(S)$ 和 $H(T)$ 是否相等，来判断 $S$ 和 $T$ 是否相等的方法。
**Hash冲突：** $H(S) = H(T)$ 时，但 $S \ne T$，则称发生了Hash冲突
> Hash 检测时 Hash 冲突的概率是衡量 Hash 算法好坏的重要指标
>> 比如冲突概率 $\le 10^{-4}$

### 多项式取模哈希
#### 多项式 Hash
将字符串看作某个进制 (Base) 下的数字串(类似直接 `stoi()`，只是进制不同)

$H(S) = \sum s_i \times {Base}^{1+n-i} = \bf{H(S[1,|S|-1]) \times Base + S[|H|]}$
$ \qquad = S_1 \times Bash^{n-1} + S_2 \times Base^{n-2} + \cdots + S_n \times Base^0$

**优点：** 字符串和 Hash 值一一对应，**不会**产生Hash冲突，且利用率高
**缺点：** 数字范围过大，难以用原始数据存储和比较

#### 多项式取模 Hash（模哈）
为了解决多项式 Hash 值域过大的问题，在效率和冲突率中的折中。

将 Hash 值对一个较大的质数取模

$H'(S) = H(S) \% mod$

**优点：** 使得Hash值可以用 `uint`/`ulong` 存储和比较
**缺点：** 小概率 Hash 冲突

因为当检验次数 $\ge \sqrt{mod}$，有较大概率发生错误。
**为了保证冲突率低，模哈使用的 $mod$ 最好超过 Hash 检测次数的平方**

#### Hash 模数
优秀的 Hash 模数首先应满足：**足够大**

**自然溢出：** 使用 `ULL` 保存Hash值，溢出 `ULL`，等同于 $\% 2^{64}$(很容易卡)

优秀的模数还一个是一个 **质数**

**质数单模：** 选取**一个**$10^9 \sim 10^{10}$ 的大质数，但是有 **广为人知** 的方法构造冲突。
> 如果在int内更多，会更有优势 (在32位计算机上)

**双模：** 进行多次不同质数的单模哈希，冲突概率为各次单模的概率乘积
> 在不泄露模数的情况下，没有已知方法可以构造冲突

##### 快速求子串 hash
$H(S) = (S_l \times Bash^{r-l} + S_{l+1}+1 \times Base^{r-l-1} + \cdots + S_r)\% mod$

令 $F(i) = H(prefix[i])$

$F(l-1) = (S_1 \times Bash^{l-2} + S_{2} \times Base^{l-3} + \cdots + S_{l-1}) \% mod$
$F(r) = (S_1 \times Bash^{r-1} + S_{2} \times Base^{r-2} + \cdots + S_{r}) \% mod$

$\therefore H(S[l,r]) = F(r) - F(l-1) \times Base^{r-l+1}$

#### 回文串
对于回文串，正向Hash和反向Hash值是一样的

#### code
```cpp
const int base = 26;
PII mod = {1000000321,1000000711};// 模数，随便塞两个素数也行
string st;// 哈希字符串
vector<PII> s(N);// 前缀和

void init(string &st,vector<PII> &s)
{
	int L = st.size();
	for(int i=1;i<=L;++i)
	{
		s[i].X = (s[i-1].X * base) % mod.X;
		s[i].X = (s[i].X + st[i]-'a')%mod.X;
		s[i].Y = (s[i-1].Y * base) % mod.Y;
		s[i].Y = (s[i].Y + st[i]-'a')%mod.X;
	}
}

PII query(int l,int r)
{
	PII res = {0,0};
	res.X = (s[r].X - s[l-1].X*qpow(base,r-l+1,mod.X));
	res.Y = (s[r].Y - s[l-1].Y*qpow(base,r-l+1,mod.Y));
	return res;
}
```