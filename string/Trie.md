## trie
### 模板
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

### 题目
#### 字符串子串插入
需要插入反复插入一个字符串的子串或者部分，每次不能新建整个串，而是从上次插入地方继续加入节点
```cpp
for(auto &i : s0)
{
	if(i == 'B')
	{
		if(st.size())	st.erase(st.end()-1);
		p = fa[p];
	}
	else if(i == 'P')
	{
		for(auto &j : st)
		{
			int c = j-'a';
			if(!nxt[p][c])	nxt[p][c] = ++ idx;
			trie[p][c] = nxt[p][c];
			fa[nxt[p][c]] = p;
			p = nxt[p][c];
		}
		mp[++ cnt] = p;
		st.clear();
	}
	else	st += i;
}
```