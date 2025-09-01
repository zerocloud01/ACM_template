## 01trie
```cpp
// 将数组加入trie树
void insert(int z)
{
	int p = 0;
	for(int i=31;i>=0;--i)
	{
		int t = (z>>i)&1;
		if(!nxt[p][t])	nxt[p][t] = ++ idx;
		p = nxt[p][t];
	}
	ext[p] = true;
}
// 判断数字是否在树中
bool find(int z)
{
    int p = 0;
    for(int i=31;i>=0;--i)
    {
        int t = (z>>i)&1;
        if(!nxt[p][t])	return false;
        p = nxt[p][t];
    }
    return ext[p];
}
```
### 求异或最大值
贪心高位不同的点
```cpp
int get_max(int x)
{
    int res = 0,p = 0;
    for(int i=31;i>=0;--i)
    {
        int t = (x>>i)&1;
        if(nxt[p][t^1])	res += (1<<i), p = nxt[p][t^1];
        else if(nxt[p][t])	p = nxt[p][t];
        else	break;
    }
    return res;
}
```