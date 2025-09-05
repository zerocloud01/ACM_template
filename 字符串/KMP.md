## KMP
求 border + kmp查找
### 模板
#### 求 border 数组
```cpp
// 从 2 开始
string st;// 模式串
string s;// 查找串

int nxt[N];
void get_next(string &st)// 求border
{
    for(int i=2;i<=st.size();++i)
    {
        nxt[i] = nxt[i-1];
        while(nxt[i] && st[nxt[i]+1] != st[i])  nxt[i] = nxt[nxt[i]];
        nxt[i] += st[nxt[i]+1] == st[i];
    }
}

int kmp(int l,int r,string& s)// 求第一个匹配的位置
{
    for(int i=l,j=0;i<=r;++i)
    {
        while(j>0 && st[j+1] != s[i])   j = nxt[j];
        j += (st[j+1] == s[i]);
        if(j == m)  return i-j+1;
    }
}

int kmp(int l,int r,string& s)// 求匹配的个数
{
    int cnt = 0;
    for(int i=l,j=0;i<=r;++i)
    {
        while(j>0 && st[j+1] != s[i])   j = nxt[j];
        j += (st[j+1] == s[i]);
        if(j == m)
        {
            cnt ++;
            j = nxt[j];
        }
    }
}
```