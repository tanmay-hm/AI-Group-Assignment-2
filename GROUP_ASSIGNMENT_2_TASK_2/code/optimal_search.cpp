#include <bits/stdc++.h>

using namespace std;

typedef unsigned long long u64;

const char* N[] = {"base","sitea","siteb","sitec","sited","sitee","sitef"};

int NR; 
int home[7] = {1,2,3,4,6,5,6}; 
bool hardR[7] = {0,0,1,0,1,0,1};


vector<int> adj[7];
// state: rover | drill<<3 | rock_i<<(6+3i); 7 = carried / held
u64 mk(int r, int d, int *p){
	u64 s = r | (u64)d<<3;
	
	for(int i=0;i<NR;i++)
		s|=(u64)p[i]<<(6+3*i);
		
	return s;
}

void un(u64 s, int& r, int& d,int *p){
	r = s & 7;
	d = s>>3 & 7;
	
	for(int i=0; i < NR; i++)
		p[i] = s>>(6+3*i) & 7;

}


int h(u64 s){
	int r, d, p[7];
	un(s,r,d,p);
	
	int n = 0;
	bool need = false;
 	
 	for(int i = 0; i < NR; i++){
 		if(p[i] == 7)
 			n+=1;
 		else if(p[i] != 0){
 			n+=2;
 		} 
 		if(hardR[i] && p[i] != 0)
 			need=true;
 	}
 	
 	if(d != 7 && need)
 		n++; 
 	if(r != 0 && n == 0)
 		n++; 
 	
 	return n;
 }


int main(int c,char**v){
	bool ext = string(v[1]) == "ext";
	
	NR = ext ? 7 : 5;
 	vector<pair<int,int>> e = {{0,1},{1,0},{1,3},{3,1},{2,4},{4,2},{3,5},{5,3},{4,5},{5,4},{5,6},{6,5},{3,4}};
 
 	if(!ext){
 		e.push_back({0,2});e.push_back({2,0});
 	}
 	
 	for(auto &x : e)
 		adj[x.first].push_back(x.second);
 		
 	int p0[7];
 	
 	for(int i = 0; i < NR; i++)
 		p0[i] = home[i];
 	u64 s0 = mk(0,5,p0);
 	
 	unordered_map<u64,int> g;
 	unordered_map<u64,pair<u64,string>> par;
 
 	typedef tuple<int,int,u64> T; 
 	priority_queue<T,vector<T>,greater<T>> pq;
 
 	g[s0] = 0;
 	pq.push({h(s0),0,s0});
 	
 	long ex=0;
 	
 	while(!pq.empty()){
 		auto [f,gc,s] = pq.top();
 		pq.pop();
 		
 		if(gc>g[s]) continue;
  
  		int r, d, p[7];
  		
  		un(s,r,d,p);
  		
  		bool goal = r == 0;
  		
  		for(int i = 0; i < NR; i++)
  			if(p[i] != 0) goal=false;
  		
  		if(goal){
  			printf("optimal length %d, expanded %ld\n",gc,ex);
	  		
	  		vector<string> pl;
	  		u64 t=s;
	  		while(t != s0){
	  			pl.push_back(par[t].second);
	  			t = par[t].first;
	  		}
	  		
	   		reverse(pl.begin(), pl.end());
	   		
	   		for(auto &x : pl)
	   			puts(x.c_str());
	   		
	   		return 0;
   		}
   		
  		ex++;
  		
  		auto push=[&](u64 t,string a){
  			if(!g.count(t) || gc + 1 <g[t]){
  				g[t] = gc+1;
  					
  				par[t]= {s,a};
  				pq.push({gc+ 1 + h(t), gc+1,t});
  			}
  		};
  		
  		for(int t : adj[r]){
  			int q[7];
  			
  			memcpy(q,p,sizeof q);
  			push(mk(t,d,q), string("move ") + N[r] + " " + N[t]);
  		}
  		
  		
  		if(d == r){
  			int q[7];
  			memcpy(q,p,sizeof q);
  			
  			push(mk(r,7,q), string("pick-drill ") + N[r]);
  		}
  		
  		int carried = 0;
  		
  		for(int i=0; i < NR; i++)
  			carried += p[i] == 7;
  
  		for(int i=0; i < NR; i++){
  			int q[7];
  			memcpy(q,p,sizeof q);
  			
   			if(p[i] == r && carried < 2  &&  (!hardR[i] || d==7)){
   				q[i]=7;
   				
   				push(mk(r,d,q), "collect rock" + to_string(i+1) + " at "+ N[r]);
   			}
   			
   			if(p[i] == 7){
   				q[i] = r;
   				push(mk(r,d,q), "deposit rock" + to_string(i+1)+ " at "+ N[r]);
   			}
   		}
 	}
	puts("no plan");
}
