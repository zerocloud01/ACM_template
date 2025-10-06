## LCA
**LCA性质**
- $u \rightarrow v$ 的简单路径 $ = u \rightarrow \text{LCA}(u,v) + \text{LCA}(u,v) \rightarrow v$
- $\text{LCA}(x,y,z) = \text{LCA} = \text{LCA}(x,\text{LCA}(y,z))$
    > 类似 `max,min,gcd`
- $\text{LCA}(x_1,x_2,x_3,\ldots,x_k) = \text{LCA}(dfs_{min},dfs_{max})$
    > `dfs` 指 `dfs序`
### 倍增LCA
`fa[i][j]` 表示节点 $i$ 向上走 $2^j$ 所到达的点
用 `dfs` 求 `fa` 数组。

`fa[x][i]` $= x$ 向上 $2^{i-1}$ 的点再往上 $2^{i-1}$ 对应的点
**初始需要设置 `fa[i][0]` 为每个 $i$ 的直接父亲**
> 父亲链上点全部已经算完 （`dfs` 性质），所以可以直接转移

**求 $\text{LCA}$**
- $x$ 跳到 $y$ 同一深度
    > 设 $dep_x > dep_y$
- 判断 $x,y$ 是否相等
- 枚举 $i$（从大到小），若 `fa[x][i]` $=$ `fa[y][i]`，则不跳跃，
    始终保持 $dep_x = dep_y$
    最后 $x,y$，将留在 $\text{LCA}(x,y)$ 的子节点
- `return fa[x][0]`
```cpp
vector<int> a[N];// 邻接表
int fa[N][30];
int dep[N];

void dfs(int p)
{
	dep[p] = dep[fa[p][0]]+1;
	for(int i=1;i<=D;++i)	fa[p][i] = fa[fa[p][i-1]][i-1];
	for(auto &i : a[p])	dfs(i);
}

int lca(int x,int y)
{
	if(dep[x] < dep[y])	swap(x,y);
	for(int i=D;i>=0;--i)
	{
		if(dep[fa[x][i]] >= dep[y])	x = fa[x][i];
	}
	if(x == y)	return x;
	for(int i=D;i>=0;--i)
	{
		if(fa[x][i] != fa[y][i])	x = fa[x][i], y = fa[y][i];
	}
	return fa[x][0];
}
```

### Tarjan LCA
- 将询问离线
- `dfs`，用并查集维护 $LCA$

因为 `dfs` 的性质，我们保证每次处理完一个节点的所有子树再处理本身。那么对于询问 $u,v$，访问到 $v$ 时，如果 $u$ 已经被访问，两者必在同一子树，只需要找到该子树的根节点即可。

又因为每次处理子节点再往上，所以 $u$ 的根（并查集）就是两者的 $LCA$。

```cpp
int n,q;
vector<int> a[N];
vector<PII> Q[N];
bitset<N> vis;
int rt[N], dep[N], ans[N], fa[N];
// 根，深度，答案，父节点（直接）

int find(int x)
{
	return rt[x] = (x == rt[x] ? x : find(rt[x]));
}

// 保证深度大的链接在深度小的上
void merge(int x,int y)
{
	int fx = find(x), fy = find(y);
	if(dep[fx] < dep[fy])	swap(fx,fy);
	rt[fx] = fy;
}

void dfs(int p)
{
	vis[p] = true;
	dep[p] = dep[fa[p]] + 1;
	for(auto &i : a[p])	dfs(i);
	for(auto &[x,y] : Q[p])
	{
		if(!vis[x])	continue;
		ans[y] = find(x);
	}
	merge(p,fa[p]);
}
```

### 区间LCA
根据上文第三条性质：
$\text{LCA}(x_1,x_2,x_3,\ldots,x_k) = \text{LCA}(dfs_{min},dfs_{max})$

用数据结构维护 $dfs_{min/max}$即可

