## 可持久化01tire
### 模板
```cpp
int n,idx;
int rt[N],nxt[N<<5][2],cnt[N<<5];
// 添加节点
void insert(int z,int &np,int lp)
{
    // 切记不要用传入值来修改
	np = ++ idx;
	int p = np;
	for(int i=D;i>=0;--i)
	{
		int t = (z>>i)&1;
		cnt[p] = cnt[lp]+1;
		nxt[p][0] = nxt[lp][0], nxt[p][1] = nxt[lp][1];
		nxt[p][t] = ++ idx;
		p = nxt[p][t], lp = nxt[lp][t];
	}
	cnt[p] = cnt[lp] + 1;
}

// 查询区间内匹配最大值
int query(int lp,int rp,int z)
{
	int res = 0;
	for(int i=D;i>=0;--i)
	{
		int t = (z>>i)&1;
		if(cnt[nxt[rp][!t]]-cnt[nxt[lp][!t]] > 0)
		{
			lp = nxt[lp][!t], rp = nxt[rp][!t];
			res += (1<<i);
		}
		else	lp = nxt[lp][t], rp = nxt[rp][t];
	}
	return res;
}

insert(x,rt[i],rt[i-1]);
```