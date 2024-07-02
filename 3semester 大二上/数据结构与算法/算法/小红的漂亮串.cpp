// 考察记忆化搜索
// 我们明显的发现是一段很长的串当中是否有red和没有der我们可以使用数位dp记录上2个位置是什么上1个位置是什么,最后是否满足有“red”
// 我们可以这样思考如果当前数位确定同时前面两个字母也确定我们可以依照数位来排可以转移所以不会漏状态

int dp[N][4][4][2];
int dfs(int pos,int u1,int u2,bool ok){
    int &v=dp[pos][u1][u2];// 考虑当前位置是不是会影响后面的位置
    
    if(!pos) return ok;
    if(~v)   return v;
    int  res=0;
    for(int i=0;i<3;i++){
        if(u1==0 && u2==1 && i==2) continue;// 我们按照 d  e  r 映射一手 这个是不合理
        res+=dfs(pos-1,u2,i,ok | (u1==2&&u2==1&&i==0));
        res%=mod;
    }
    res+=23*dfs(pos-1,u2,3,ok);// 其他23个位置是一样的默认为3即可
    res%=mod;
    return v=res;
}

void solve(){
    memset(dp,-1,sizeof dp);
    cin>>n;
    cout<<dfs(n,3,3,0)<<endl;
    return ;
}