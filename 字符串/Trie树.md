## trie
### code
```cpp
int idx,nxt[N],ext[N];

void insert(string &st,int id)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		if(!nxt[p][c])	nxt[p][c] = ++ idx;
		p = nxt[p][c];
	}
	ext[p] = id;
}

bool find(string &st)
{
	int p = 0;
	for(int i=0;i<st.size();++i)
	{
		int c = st[i]-'a';
		if(!nxt[p][c])	return false;
		p = nxt[p][c];
	}
	return ext[p];
}
```