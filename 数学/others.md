### others
#### $\mod x$ 矩阵填数
[24ICPC沈阳B](https://codeforces.com/gym/105578/problem/B)
$c_{i,j} = a_i \times b_j \mod (n\times m)$

在 $0 \le a_i,b_j \le n \times m$ 情况下填写 $a,b$，让 $c$ 所不重复。

```cpp
void func(void)
{
	int n,m;    cin >> n >> m;
    int g=__gcd(n,m);
    if(g!=1) {cout<<"No"<<endl;return;}
    cout << "Yes\n";
    int p1 = m!=1, p2 = n!=1;
    for(int i=p1;i<n*m;i+=m)  cout << i << ' ';   cout << '\n';
    for(int i=p2;i<n*m;i+=n)  cout << i << ' ';   cout << '\n';
    
}
```