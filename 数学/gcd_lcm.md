## gcd_lcm
```cpp
int gcd(int a,int b){
   return (b ? gcd(b,a%b) : a);
}

int lcm(int a,int b){
   return a/gcd(a,b)*b;
}
```

### 差分gcd
推导于辗转相除法：$\gcd(a,b) = \gcd(a,|b-a|)$
差分数组的 $\gcd$ 是原数组 $\gcd$ 的倍数。
若是 $a_1$ 差分 $\gcd$ 的倍数，则互相相等。
