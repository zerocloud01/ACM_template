## Manacher
### 模板
为了处理奇偶串，我们给串之间与首位添加 $\#$，或者其他不出现在字符集的字符。

$R_i$ 表示以 $i$ 为回文中心的回文串的回文半径
```cpp
int L[N];

void manacher(string &s)
{
	string st = "_#";
	for(auto &i : s)	st += i, st += '#';
	int p = 0;
	L[0] = 1;
	for(int i=1;i<st.size();++i)
	{
		int r = p+L[p]-1;
		if(i <= r)	L[i] = min(L[2*p-i],r-i+1);
		else	L[i] = 1;
		while(st[i-L[i]] == st[i+L[i]])	L[i] ++;
		if(i+L[i]-1 > r)	p = i;
	}
}
```
实际回文串长度 $= L_i - 1$