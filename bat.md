## Bat
```cpp
// gen
#include<bits/stdc++.h>
using namespace std;

signed main(void)
{
    srand(time(0));// 随机数，需要<random>库

    int x = rand()%100;
    int y = rand()%100;

    cout << x << ' ' << y << '\n';

    return 0;
}
// bat
#include <bits/stdc++.h>
using namespace std;

int main() 
{
    int T = 1e3; // 数据次数，也可以写死循环直到wa。
    for(int i=1;i<=100;++i)
    {
        system("generator.exe > data.in");
        system("std.exe < data.in > std.out");
        system("solve.exe < data.in > solve.out");
        cout << "test:" << i;
        if(system("fc std.out solve.out > diff.txt"))
        {
            cout << "WA\n";
            return;
        }
        else    cout << "AC\n";
    }

    return 0;
}
```