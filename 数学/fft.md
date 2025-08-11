## fft
快速傅里叶变换

$fft$ 求解多项式乘法的 $n$ 个结果，$ifft$（逆变换）求解系数，具体使用线代逆矩阵性质。
这样可以求解多项式系数。
### 高精度乘法
**保证存储系数的数组长度 $\ge$ 被计算的两个数长度和的两倍**

高精度 $\times$ 高精度理解为两个多项式相乘，乘出的结果多项式的系数就是乘法计算的结果，因为代入对应进制及是对应的数。

### code
#### 复数
```cpp
struct cpx
{
	double x,y;
	cpx operator + (const cpx i)	{return {x+i.x,y+i.y};}
	cpx operator - (const cpx i)	{return {x-i.x,y-i.y};}
	cpx operator * (const cpx i)	{return {x*i.x-y*i.y,x*i.y+y*i.x};}
};
```
#### 归并
```cpp
void fft(cpx a[],int L,int op)
{
	if(L == 1)	return;
	cpx a1[L>>1], a2[L>>1];
	for(int i=0;i<(L>>1);++i)	a1[i] = a[i<<1], a2[i] = a[i<<1|1];
	fft(a1,L>>1,op), fft(a2,L>>1,op);
	cpx wk = {cos(2*pi/L),sin(2*pi/L)*op}, w = {1,0};
	for(int i=0;i<(L>>1);++i,w=w*wk)
	{
		a[i] = a1[i] + a2[i]*w;
		a[i+(L>>1)] = a1[i] - a2[i]*w;
	}
}
```
#### 迭代
```cpp
int r[N];
cpx a[N],b[N];
void fft(cpx a[],int L,int op)
{
	// 反转变换
	for(int i=0;i<L;++i)	r[i] = r[i>>1]/2 + (i&1 ? L>>1 : 0);
	for(int i=0;i<L;++i)
	{
		if(i < r[i])	swap(a[i],a[r[i]]);
	}
	for(int len=2;len<=L;len<<=1)
	{
		cpx wk = {cos(2*pi/len),sin(2*pi/len)*op};
		for(int i=0;i<L;i+=len)
		{
			cpx w = {1,0};
			for(int j=0;j<(len>>1);++j,w=w*wk)
			{
				cpx x = a[i+j], y = a[i+j+(len>>1)]*w;
				a[i+j] = x+y, a[i+j+(len>>1)] = x-y;
			}
		}
	}
}
```