## 多项式Hash
### 多项式双模hash
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