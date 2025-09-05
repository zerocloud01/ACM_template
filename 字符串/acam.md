## ac自动机
### 模板
trie树+fail（失配）指针
每个串保存trie树中最长相同前缀，这样失配的时候可以直接跳转匹配。

```cpp
int n,idx;
int nxt[N][26],fail[N];
bitset<N> ext;
// trie
void insert(string &st,int id)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i] - 'a';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
    ext[p] = id;
}
// acam
void build_acam(void)
{
	queue<int> q;
	for(int i=0;i<D;++i)
		if(nxt[0][i])	q.push(nxt[0][i]);
	while(q.size())
	{
		int p = q.front();	q.pop();
		for(int i=0;i<26;++i)
		{
			if(!nxt[p][i]) nxt[p][i] = nxt[fail[p]][i];
            else
            {
                int ps = nxt[p][i];	q.push(ps);
                fail[ps] = nxt[fail[p]][i];
            }
			
		}
	}
}

void query_acam(string &st)
{
	for(int i=0,p=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		// 因为trie树的节点被重构了，所以可以直接跑
		p = nxt[p][c];
		// do...
	}
}
```