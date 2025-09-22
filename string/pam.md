## 回文自动机
### 模板
```cpp
int idx,lst;// 当前节点，最后指向节点
int nxt[N][26],len[N],fail[N];// 子节点指针，回文长度，失配指针
string st;
// 求 fail
int get_fail(int k,int x)
{
	while(st[k-len[x]-1] != st[k])	x = fail[x];
	return x;
}

void build_pam(void)
{
    // 保证 0 - 1 互相指向，且新节点从 2 开始，因为 01 各咋占一个
	len[0] = 0, fail[0] = 1;
	len[1] = -1, fail[1] = 0;
	idx = 1;
	for(int i=1;i<st.size();++i)
	{
		int p = get_fail(i,lst), c = st[i] - 'a';
		if(!nxt[p][c])
		{
			len[++ idx] = len[p] + 2;
			fail[idx] = nxt[get_fail(i,fail[p])][c];
			nxt[p][c] = idx;
		}
		lst = nxt[p][c];
	}
}
```