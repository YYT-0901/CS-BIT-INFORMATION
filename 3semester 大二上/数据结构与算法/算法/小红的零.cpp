// 数学公式要变形
// 莫急莫急先读题
// 考察思维+树状数组
#include <bits/stdc++.h>
using namespace std;
#define lowbit(x) (x&(-x))
#define endl "\n"
#define ios ios::sync_with_stdio(0); cin.tie(0),cout.tie(0);
#define LF(x)   fixed<<setprecision(x)// c++ 保留小数
typedef long long LL;
typedef pair<int, int> PII;
const int N=1000010,M=1010,INF=0x3f3f3f3f,mod=1e9+7;
const double pai=acos(-1.0);// pai
map<int,int> mp;
int t,n,m;
int w[N];
int cnt5[N],cnt2[N];
LL  sum5[N],sum2[N];

LL ct5[N],ct2[N];
LL sm5[N],sm2[N];

void add(LL tr[],int x,LL k){
    for(int i=x;i<=m;i+=lowbit(i)) tr[i]+=k;
}

LL query(LL tr[],int x){
    LL res=0;
    for(int i=x;i;i-=lowbit(i)) res+=tr[i];
    return res;
}

void solve()
{
    cin>>n;
    for(int i=1;i<=n;i++){
        int x; cin>>x;
        while(x%2==0) cnt2[i]++,x/=2;
        while(x%5==0) cnt5[i]++,x/=5;
        sum2[i]=sum2[i-1]+cnt2[i];
        sum5[i]=sum5[i-1]+cnt5[i];
    }
    
    // 求出前缀2 和  5 的数量
    vector<int> res;
    for(int i=1;i<=n;i++) res.push_back(sum2[i]-sum5[i]);
    
    // 我们假设固定了右端点,对于r 我们考虑左边的区间为[1,r-1],那么我们有两种情况要处理
    // 1. 对于sum5[r]-sum5[l]>=sum2[r]-sum2[l]
    // 我们考虑带来的贡献就是 满足条件的1都数量 y-> y*sum2[r]-这y个sum2[l]的和
    // 进一步推导式子可以变为 sum5[r]-sum2[r]>=sum5[l]-sum2[l]// 满足这个要求的
    // 这个时候我们就是可以来考虑前缀中满足小于这个的数量的 
    // 我们考虑树状数组来维护,同时把每一个位置的数量加入其中考虑到   有负数重复 我们离散处理即可
    
    // 2.对于sum2[r]-sum2[l]>=sum5[r]-sum5[l] 同理变形-> sum2[r]-sum5[r]>=sum2[l]-sum5[l]
    // 接着我们如果按照上面的排序的话就是和2是反过来的情况所以2就是倒着来求即可
    
    sort(res.begin(),res.end());
    
    res.erase(unique(res.begin(),res.end()),res.end());
    
    m=res.size();
    
    int pos=lower_bound(res.begin(),res.end(),0)-res.begin()+1;
    
    // 为什么要加因为考虑前缀和到0的位置
    add(ct2,pos,1ll);
    add(ct5,pos,1ll);
    
    LL ans=0;
    for(int i=1;i<=n;i++){
        int pos=lower_bound(res.begin(),res.end(),sum2[i]-sum5[i])-res.begin()+1;
        ans+=(LL)query(ct5,pos)*sum5[i]-query(sm5,pos);
        ans+=(LL)(query(ct2,m)-query(ct2,pos))*sum2[i]-(query(sm2,m)-query(sm2,pos));
        add(ct2,pos,1ll);
        add(ct5,pos,1ll);
        add(sm2,pos,sum2[i]);
        add(sm5,pos,sum5[i]);
    }
    cout<<ans<<endl;
    return ;
}
signed main ()
{
    ios// 不能有printf puts scanf
    int t=1;
    while(t--){
    	 solve();
    }
}