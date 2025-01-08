## 一、实验目的

本实验目的是加强学生对位级运算的理解及熟练使用的能力。

## 二、报告要求

本报告要求学生把实验中实现的所有函数逐一进行分析说明，写出实现的依据，也就是推理过程，可以是一个简单的数学证明，也可以是代码分析，根据实现中你的想法不同而异。

## 三、函数分析

1. bitXor函数

**函数要求：**

函数名 | bitXor
-|-
参数 | int x, int y 
功能实现 | x^y
要求 | 只能使用 ~ 和 & 实现 

**实现分析：**

很简单,根据离散数学的知识可以推出`~((~(x&(~y))) & (~((~x)&y)))` = `x^y`

**函数实现：**

```C
int bitXor(int x, int y) {
  // 代码实现
  return ~((~(x&(~y))) & (~((~x)&y)));
}
```

---

2. getByte函数

**函数要求：**

函数名 | getByte 
-|-
参数 | int x, int y 
功能实现 | Extract byte n from word x 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

从整型x中取出第n个字节，只需要x往右移n个字节（即右移n\*8位）之后再&上0xFF即可

**函数实现：**

```C
int getByte(int x, int n) {
  return (x>>(n<<3)) & 0xFF;
}
```

---

3. logicalShift函数

**函数要求：**

函数名 | logicalShift 
-|-
参数 | int x, int n 
功能实现 | shift x to the right by n, using a logical shift 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

要实现逻辑右移的话，需要将算术右移得到的值&上00…11…（前面有n个零，后面都为1）

**函数实现：**

```C
int logicalShift(int x, int n) {
  int as = (x>>n);
  int mask = ((~(1<<31)>>n)<<1)+1;
  return as & mask;
}
```

---

4. bitCount函数

**函数要求：**

函数名 | bitCount 
-|-
参数 | int x 
功能实现 | returns count of number of 1's in word 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

采用分治的方法,首先求出两个一组中1的个数,以此类推求出4,8,16一组中1的个数,将x的bit表示分成两个一组,组内一位相加,再将x1的bit表示分成4个一组,组内两位相加,以此类推.

**函数实现：**

```C
int bitCount(int x) {
  int mask1;
  int mask2;
  int mask4;
  int mask8;
  int mask16;

  mask1 = 0x55 | 0x55 << 8;
  mask1 = mask1 | mask1 << 16;
  mask2 = 0x33 | 0x33 << 8;
  mask2 = mask2 | mask2 << 16;
  mask4 = 0x0F | 0x0F << 8;
  mask4 = mask4 | mask4 << 16;
  mask8 = 0xFF | 0xFF << 16;
  mask16 = 0xFF | 0xFF << 8;

  x = (x & mask1) + ((x >> 1) & mask1);
  x = (x & mask2) + ((x >> 2) & mask2);
  x = (x + (x >> 4)) & mask4;
  x = (x + (x >> 8)) & mask8;
  x = (x + (x >> 16)) & mask16;

  return x;
}
```

---

5. conditional函数

**函数要求：**

函数名 | conditional 
-|-
参数 | int x, int y, int z 
功能实现 | same as x ? y : z           
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

首先，函数接收三个整数参数 `x`、`y` 和 `z`。

对 `x` 进行两次逻辑非操作，这实际上就是将 `x` 转换为0或1。如果 `x` 是0，那么 `!!x` 就是1；如果 `x` 是任何非0值，`!!x` 也是1。

对 `x` 进行按位取反操作，然后加1。如果 `x` 是0，那么 `~x` 就是-1（在计算机中通常表示为全1的二进制），加1后 `x` 变为2。如果 `x` 是1，`~x` 就是-2（全0的二进制），加1后 `x` 变为-1，但在整数溢出的情况下，会变成一个很大的正数。

函数计算 `x & y` 和 `~x & z` 的按位或结果作为返回值。这里的 `x & y` 就是 `x` 和 `y` 的按位与操作，而 `~x & z` 是 `x` 的按位取反与 `z` 的按位与操作。

**函数实现：**

```C
int conditional(int x, int y, int z) {
  x = !!x;
  x = ~x+1;
  return (x&y)|(~x&z);
}
```

---

6. tmin函数

**函数要求：**

函数名 | tmin 
-|-
参数 | 无 
功能实现 | return minimum two's complement integer 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

在32位有符号整数中，最左边的位是符号位，用来表示整数的正负。如果符号位是0，那么整数是正数；如果符号位是1，那么整数是负数。

当我们将 `0x1` 左移31位时，我们实际上是在创建一个二进制数，它有31个0，后面跟着一个1。这个数在二进制中表示为 `0...0000000000000000000000000000001`（31个0后面跟着一个1）。这个数在十进制中表示为 `-2^31`，因为在32位有符号整数中，最左边的位是符号位，当它为1时，表示的是一个负数。

因此，`0x1 << 31` 实际上计算的是 `-2^31`，这是32位有符号整数可以表示的最小值。

**函数实现：**

```C
int tmin(void) {
  return 0x1 << 31;
}
```

---

7. fitsBits函数

**函数要求：**

函数名 | fitsBits 
-|-
参数 | int x, int n 
功能实现 | return 1 if x can be represented as an n-bit, two's complement integer. 
要求 | 只能使用 ! ~ & ^ \| + << >>                                  

**实现分析：**

创建一个掩码,命名为`tool`，其所有位都是1。在32位系统中，这相当于 `-1`，其二进制表示为32个连续的1。

`x` 被右移 `n + tool` 位。由于 `tool` 是 `-1`，这个操作实际上是将 `x` 右移 `n - 1` 位。这一步的目的是将 `x` 的最高 `n - 1` 位（不包括最低位，即2的0次方位）移动到最低位的位置。

`x` 被右移31位，这样 `x` 的符号位就被移动到了最低位。这一步是为了单独获取 `x` 的符号位。

将上述两个右移操作的结果进行异或操作。如果 `x` 能够被 `n` 位二进制数表示，那么它的最高 `n - 1` 位（不包括最低位）应该与符号位相同。如果它们相同，异或操作的结果将是0；如果不同，结果将是非0值。

对异或操作的结果取逻辑非。如果异或结果是0（即 `x` 能够被 `n` 位二进制数表示），逻辑非操作将返回1；如果异或结果是非0（即 `x` 不能被 `n` 位二进制数表示），逻辑非操作将返回0。

**函数实现：**

```C
int fitsBits(int x, int n) {
  int tool = ~0;
  x = (x >> (n + tool)) ^ (x >> 31);
  return !x;
}
```

---
8. dividePower2函数

**函数要求：**

函数名 | dividePower2 
-|-
参数 | int x, int n 
功能实现 | Compute x/(2^n), for 0 <= n <= 30 Round toward zero 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

将 `x` 右移31位，得到 `x` 的符号位。如果 `x` 是正数，`mid` 将是0；如果 `x` 是负数，`mid` 将是-1（在32位有符号整数中，-1的二进制表示为全1）。

首先计算 `2^n`，然后加上 `mid` 的值。由于 `mid` 要么是0要么是-1，这一步实际上是在计算 `2^n` 时考虑 `x` 的符号：

- 如果 `x` 是正数，`mid` 是0，`tool` 就是0。
- 如果 `x` 是负数，`mid` 是-1，`tool` 就是 `-1 & -1`，结果也是-1。

这一步的目的是为负数的 `x` 计算一个调整值，以便在执行右移操作时能够正确处理负数的除法。

将 `x` 与 `tool` 相加，然后右移 `n` 位。这里的加法是为了处理负数的情况：

- 对于正数，`tool` 是0，加法不会改变 `x` 的值。
- 对于负数，`tool` 是-1，加法实际上是减去1，这可以防止在右移时发生错误的截断。

右移 `n` 位的操作实际上是将 `x` 除以 `2^n`。对于正数，这是直接的除法；对于负数，由于之前的调整，也能正确地执行除法。

**函数实现：**

```C
int dividePower2(int x, int n) {
    int mid = x >> 31;
    int tool = ((1 << n) + mid) & mid;
    return (x+tool) >> n;
}
```

---
9. negate函数

**函数要求：**

函数名 | negate 
-|-
参数 | int , int
功能实现 | return -x                   
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

按位取反再加一

**函数实现：**

```C
int negate(int x) {
  return ~x+1;
}
```

---
10. howManyBits函数

**函数要求：**

函数名 | howManyBits 
-|-
参数 | int x 
功能实现 | return the minimum number of bits required to represent x in two's complement 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

首先进行符号处理,通过右移31位获取 `x` 的符号位。如果 `x` 是正数，符号位是0；如果 `x` 是负数，符号位是1。

将 `x` 转换为其绝对值。如果 `x` 是正数，`sign` 是0，所以 `~x` 与 `sign` 的按位与操作结果是 `~x`，`x` 与 `~sign` 的按位与操作结果是 `x`，最终 `x` 不变。如果 `x` 是负数，`sign` 是-1（所有位都是1），所以 `~x` 与 `sign` 的按位与操作结果是 `x` 的正数形式，`x` 与 `~sign` 的按位与操作结果是0，最终 `x` 变为其正数形式。

然后进行位运算

将所有找到的非零位的数量相加，并加1（因为 `x` 至少有一个非零位，否则 `x` 就是0）。

**函数实现：**

```C
int howManyBits(int x) {
  int b16,b8,b4,b2,b1,b0;
  int sign = x >> 31;
  x = (sign &~ x) | (~sign & x);

  b16 = !!(x >> 16) << 4;
  x = x >> b16;
  b8 = !!(x >> 8) << 3;
  x = x >> b8;

  b4 = !!(x >> 4) << 2;
  x = x >> b4;
  b2 = !!(x >> 2) << 1;
  x = x >> b2;
  b1 = !!(x >> 1);
  x = x >> b1;
  b0 = x;
  return b16+b8+b4+b2+b1+b0+1;
}
```

---
11. isLessOrEqual函数

**函数要求：**

函数名 | isLessOrEqual 
-|-
参数 | int x, int y 
功能实现 | if x <= y  then return 1, else return 0 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

**计算 `x` 的负数表示**：`int negX = ~x + 1;` 这行代码通过取反 `x` 并加1来计算 `x` 的补码形式，即 `-x`。

**计算 `x` 和 `y` 的和**：`int addX = negX + y;` 这行代码将 `-x` 和 `y` 相加，得到 `y - x`。

**检查符号位**：`int checkSign = addX >> 31 & 1;` 这行代码通过将 `y - x` 右移31位并和1进行按位与操作，来检查 `y - x` 的符号位。如果 `y - x` 是负数，符号位为1；如果是正数或零，符号位为0。

**获取最高位**：`int leftBit = 1 << 31;` 这行代码创建一个只在第32位（从0开始计数）有1的整数。

**检查 `x` 和 `y` 的最高位**：`int xLeft = x & leftBit;` 和 `int yLeft = y & leftBit;` 这两行代码分别检查 `x` 和 `y` 的最高位是否为1。

**计算最高位的异或**：`int bitXor = xLeft ^ yLeft;` 这行代码计算 `x` 和 `y` 的最高位的异或值。

**检查异或结果的符号位**：`bitXor = (bitXor >> 31)&1;` 这行代码将 `bitXor` 右移31位并和1进行按位与操作，来检查 `bitXor` 的符号位。如果 `x` 和 `y` 的符号不同，符号位为1；如果相同，符号位为0。

**组合条件判断**：

- `(!bitXor)&(!checkSign)`：如果 `x` 和 `y` 的符号相同，并且 `y - x` 是非负数（即 `x` 大于等于 `y`），则返回1。
- `bitXor&(xLeft>>31)`：如果 `x` 和 `y` 的符号不同，并且 `x` 是负数（即 `x` 的符号位为1），则返回1。

**函数实现：**

```C
int isLessOrEqual(int x, int y) {
  int negX = ~x + 1;
  int addX = negX + y;
  int checkSign = addX >> 31 & 1;
  int leftBit = 1 << 31;
  int xLeft = x & leftBit;
  int yLeft = y & leftBit;
  int bitXor = xLeft ^ yLeft;
  bitXor = (bitXor >> 31)&1;

  return ((!bitXor)&(!checkSign)) | (bitXor&(xLeft>>31));
}
```

---
12. intLog2函数

**函数要求：**

函数名 | intLog2 
-|-
参数 | int x 
功能实现 | return floor(log base 2 of x), where x > 0 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

这个函数通过逐步检查 `x` 的高位，每次检查一个更小的范围，并根据检查结果更新 `bitsNumber` 的值。最终，`bitsNumber` 表示 `x` 的二进制表示中最高位1的位置，也就是 `log2(x)` 的向下取整值。如果 `x` 是0，这个函数将返回0，因为0的对数是未定义的，但按照向下取整的定义，结果为0。

**函数实现：**

```C
int intLog2(int x) {
  int bitsNumber = (!!(x>>16)) << 4;
  bitsNumber = bitsNumber + ((!!(x >> (bitsNumber + 8))) << 3);
  bitsNumber = bitsNumber + ((!!(x >> (bitsNumber + 4))) << 2);
  bitsNumber = bitsNumber + ((!!(x >> (bitsNumber + 2))) << 1);
  bitsNumber = bitsNumber + (!!(x >> (bitsNumber + 1)));

  return bitsNumber;
}
```

---
13. floatAbsVal函数

**函数要求：**

函数名 | floatAbsVal 
-|-
参数 | unsigned uf 
功能实现 | Return bit-level equivalent of absolute value of f for floating point argument f. 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

首先使用位掩码 `0x7f800000` 来提取 `uf` 的指数部分，然后右移23位使其变为最低的8位。如果指数部分为255（即二进制的11111111），这通常表示这个浮点数是特殊值（无穷大或NaN）。

将 `uf` 的位向左移动9位，如果 `uf` 是特殊值（无穷大或NaN），那么移动后的结果非零。如果 `uf` 已经是特殊值，并且非零，那么直接返回 `uf`，因为特殊值的绝对值就是它们本身。

如果 `uf` 不是特殊值，那么通过与操作 `& 0x7fffffff` 来清除符号位（最高位），从而得到 `uf` 的绝对值。掩码 `0x7fffffff` 是一个32位的有符号整数，其最高位是0，其他位都是1，这样就能保留 `uf` 的所有位，除了最高位。

**函数实现：**

```C
unsigned floatAbsVal(unsigned uf) {
  if((uf&0x7f800000)>>23 == 255 && uf<<9) return uf;
  return uf & 0x7fffffff;
}
```

---
14. floatScale1d2函数

**函数要求：**

函数名 | floatScale1d2 
-|-
参数 | unsigned uf                                                  
功能实现 | Return bit-level equivalent of expression 0.5*f for floating point argument f. 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

提取指数和符号位

处理特殊值

处理大指数值

处理小于1.5的值

**函数实现：**

```C
unsigned floatScale1d2(unsigned uf) {
  int E = (uf&0x7f800000) >>23;
  int S = uf&0x80000000;
  if((uf&0x7fffffff) >= 0x7f800000) return uf;
  if(E>1) return (uf&0x807fffff) | (--E)<<23;
  else {
	  if((uf&0x3)==0x3) uf+=0x2;
	  return ((uf>>1)&0x007fffff)|S;
  }
}
```

---
15. floatFloat2Int函数

**函数要求：**

函数名 | floatFloat2Int 
-|-
参数 | unsigned uf 
功能实现 | Return bit-level equivalent of expression (int) f for floating point argument f. 
要求 | 只能使用 ! ~ & ^ \| + << >> 

**实现分析：**

1. **提取符号位**：
   - `int s = uf>>31;` 这行代码提取 `uf` 的符号位，并将其移动到最低位。
2. **计算指数**：
   - `int exp = ((uf&0x7f800000)>>23)-127;` 这行代码提取 `uf` 的指数部分，右移23位后减去127（偏移量），得到真实的指数值。
3. **提取并调整尾数**：
   - `int frac = (uf&0x007fffff) | 0x00800000;` 这行代码提取 `uf` 的尾数部分，并添加一个隐含的1（`0x00800000`），这是为了模拟规格化数的1.xxxx形式。
4. **处理特殊情况**：
   - `if(!(uf&0x7fffffff)) return 0;` 如果 `uf` 是0，直接返回0。
   - `if(exp > 31) return 0x80000000;` 如果指数大于31，意味着结果超出32位整数的表示范围，返回最小负数。
   - `if(exp < 0) return 0;` 如果指数小于0，且不是去规格化数或特殊值，意味着结果为0。
5. **调整尾数的位数**：
   - `if(exp > 23) frac <<= (exp-23);` 如果指数大于23，说明尾数需要左移以得到正确的整数结果。
   - `else frac >>= (23-exp);` 如果指数小于23，说明尾数需要右移。
6. **处理符号和溢出**：
   - `if(!((frac>>31)^s)) return frac;` 如果尾数的符号位和 `uf` 的符号位相同，说明没有符号溢出，直接返回结果。
   - `else if(frac>>31) return 0x80000000;` 如果尾数的符号位为1，且原 `uf` 的符号位为0，说明有符号溢出，返回最小负数。
   - `else return ~frac+1;` 如果尾数的符号位为0，且原 `uf` 的符号位为1，说明需要取反加1来得到正确的负数结果。

**函数实现：**

```C
int floatFloat2Int(unsigned uf) {
  int s = uf>>31;
  int exp = ((uf&0x7f800000)>>23)-127;
  int frac = (uf&0x007fffff) | 0x00800000;
  if(!(uf&0x7fffffff)) return 0;

  if(exp > 31) return 0x80000000;
  if(exp < 0) return 0;

  if(exp > 23) frac <<= (exp-23);
  else frac >>= (23-exp);

  if(!((frac>>31)^s)) return frac;
  else if(frac>>31) return 0x80000000;
  else return ~frac+1;

}
```


## 四、实验总结

通过本次实验，我对位级操作有了更深入的理解，并且通过实际编码实践，提高了我使用这些操作解决实际问题的能力。以下是我对实验中每个函数简单的总结：

1. **bitXor函数**：通过使用按位取反和按位与操作，我学会了如何不使用按位异或操作来实现异或功能。
2. **getByte函数**：这个函数让我理解了如何通过位移和掩码操作来提取整数中的特定字节。
3. **logicalShift函数**：我学习了如何实现逻辑右移操作，即使在处理负数时也能保持高位为0。
4. **bitCount函数**：通过这个函数，我掌握了如何使用位级操作来计数一个整数中1的个数。
5. **conditional函数**：我学会了如何仅使用位级操作来实现条件选择功能。
6. **tmin函数**：这个函数让我了解了如何通过位移操作得到最小的32位有符号整数。
7. **fitsBits函数**：我学习了如何判断一个整数是否能用指定数量的比特位来表示。
8. **dividePower2函数**：通过这个函数，我掌握了如何通过位移操作来实现除以2的幂次方。
9. **negate函数**：我学会了如何仅使用位级操作来实现取反功能。
10. **howManyBits函数**：这个函数让我理解了如何计算表示一个整数所需的最小位数。
11. **isLessOrEqual函数**：我学习了如何不使用比较操作符来判断一个整数是否小于或等于另一个整数。
12. **intLog2函数**：通过这个函数，我掌握了如何计算一个整数的以2为底的对数。
13. **floatAbsVal函数**：我学会了如何在不使用数学函数的情况下计算浮点数的绝对值。
14. **floatScale1d2函数**：这个函数让我了解了如何对浮点数进行位级操作以实现乘以0.5的功能。
15. **floatFloat2Int函数**：我学习了如何将浮点数转换为整数，同时处理各种特殊情况，如溢出和去规格化数。

