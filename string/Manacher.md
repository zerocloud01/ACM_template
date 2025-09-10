## Manacher
### 模板
为了处理奇偶串，我们给串之间与首位添加 $\#$，或者其他不出现在字符集的字符。

$R_i$ 表示以 $i$ 为回文中心的回文串的回文半径
```cpp
int R[N];

void manacher(string &s)
{
	string st = "_#";
	for(auto &i : s)	st += i, st += '#';
	int p = 0,ans = 0;
	R[0] = 1;
	for(int i=2;i<st.size();++i)
	{
		int r = p+R[p]-1;
		if(i <= p)	R[i] = min(R[2*p-i],p-i+1);
		while(st[i-R[i]] == st[i+R[i]])	R[i] ++;
		if(i+R[i]-1 > r)	p = i;
	}
}
```
实际回文串长度 $= R_i - 1$