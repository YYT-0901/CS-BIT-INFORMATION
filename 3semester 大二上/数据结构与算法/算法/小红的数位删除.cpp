// 考察二进制暴力枚举
//我们可以发现数位只有9位我们可以直接暴力枚举每个数的删除位置,这里考虑使用二进制暴力枚举比较好

void solve()
{
    int a,b; cin>>a>>b;
    string x=to_string(a),y=to_string(b);
    int cnt1=x.size(),cnt2=y.size();
    int ans=INF;
    for(int i=1;i<1<<cnt1;i++){
        int v=0;
        for(int j=0;j<cnt1;j++){
            if(i>>j&1) v=v*10+(x[j]-'0');
        }
        
        for(int j=1;j<1<<cnt2;j++){
            int w=0;
            for(int k=0;k<cnt2;k++){
                 if(j>>k&1) w=w*10+(y[k]-'0');
             }
             // 防止mod0
             if(v==0 || w==0) ans=min(ans,cnt1-(int)__builtin_popcountll(i)+cnt2-__builtin_popcountll(j));
             else if(v%w==0 || w%v==0){
                 ans=min(ans,cnt1-(int)__builtin_popcountll(i)+cnt2-__builtin_popcountll(j));
             }
        }
    }
    cout<<(ans==INF ? -1 : ans)<<endl;
    return ;