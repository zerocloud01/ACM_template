## ntt
> 叠甲：因为本人不是数论手，记录的只为个人理解，可能不太准确。

因为 $fft$ 涉及复数，计算用到了浮点数，容易产生浮点误差，所以我们思考能否使用整数来实现单位圆复数的性质。

利用原根的性质，也可以实现周期性

**模数 $p$ 需要是 $q \times 2^k + 1$ 的素数**
|原根|模数 $p$|分解 $p$|$最大长度$|
|-|-|-|-|
|$3$|$49762049$|$7 \times 2^{26} + 1$|$2^{26}$|
|$3$|$998244353$|$119 \times 2^{23} + 1$|$2^{26}$|
|$3$|$2291701377$|$17 \times 2^{27} + 1$|$2^{27}$|

求逆则直接乘逆元

### 归并
```cpp
const int P = 998244353;
const int G = 3;
const int inv_G = 332748118;// inv(g)

void ntt(int a[],int L,int op)
{
	if(L == 1)	return;
	int a1[L>>1], a2[L>>1];
	for(int i=0;i<(L>>1);++i)	a1[i] = a[i<<1], a2[i] = a[i<<1|1];
	ntt(a1,L>>1,op), ntt(a2,L>>1,op);
	int gk = qpow(op == 1 ? G : inv_G,(P-1)/L), g = 1;
	for(int i=0;i<(L>>1);++i,g=g*gk%P)
	{
		a[i] = (a1[i] + a2[i]*g%P)%P;
		a[i+(L>>1)] = (a1[i] - a2[i]*g%P+P)%P;
	}
}
```

### 迭代
和fft一模一样
```cpp
void ntt(vector<int> &a,int L,int op)
{
	vector<int> r(L);
	for(int i=0;i<L;++i)	r[i] =  r[(i>>1)]/2+(i&1 ? L>>1 : 0);
	for(int i=0;i<L;++i)
	{
		if(i < r[i])	swap(a[i],a[r[i]]);
	}
	for(int i=2;i<=L;i<<=1)
	{
		int gk = qpow(op==1 ? G : inv_G,(P-1)/i);
		for(int j=0;j<L;j+=i)
		{
			int g = 1;
			for(int k=j;k<j+(i>>1);++k,g=g*gk%P)
			{
				int x = a[k], y = a[k+(i>>1)]*g%P;
				a[k] = (x+y)%P, a[k+(i>>1)] = (x-y+P)%P;
			}
		}
	}
}
```