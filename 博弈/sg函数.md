### 记忆化搜索求sg函数
```cpp
int get_sg(int p)
{
	// if(p == 0)	return 0;// 根节点为 0
	if(sg[p] != -1)	return sg[p];// 记忆化搜索，访问过直接返回
    // 求mex，uset比set快一些
	unordered_set<int> st;
	for(auto &i : a[p])	st.insert(get_sg(i));
	int mex = 0;
	while(true)
	{
		if(!st.count(mex))	return (sg[p] = mex);
		mex ++;
	}
}
```