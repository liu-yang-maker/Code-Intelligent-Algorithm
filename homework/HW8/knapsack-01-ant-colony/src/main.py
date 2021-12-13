import util
import random
# step 1 : load data

data = util.load('../test-set/test.CSV')

c,n,v_max,w,v,res = data # 从数据中获取的各个参数

# step 2 : 初始化参数

m = n                                               # 蚂蚁的数量
alpha = 0.7                                         # 信息素重要程度因子
beta = 0.3                                          # 启发函数重要程度因子
rho = 0.1                                           # 信息素挥发因子
Q = 1                                               # 常系数
Eta = [v[i]/w[i] for i in range(0,n)]               # 启发函数
aver_Eta = sum(Eta) / len(Eta)
Tau = [ aver_Eta for i in range(0,n)]               # 信息素向量（背包问题中表示每个物品上的信息素的量）
Visited = []                                        # 访问记录数组 Visited[k] 表示第k只蚂蚁已经访问过的物品
Solution = []                                       # solution(k,j)表示第k个蚂蚁是否装第j个物品   
iter = 0                                            # 迭代初始值
iter_max = 60                                       # 迭代最大次数
# 全局最优
global_solution = [ 0 for i in range(0,n)] 
maxV = 0
iter_max_solution = [ [ 0 for j in range(0,n)] for i in range(0,iter_max)]
iter_maxV =  [ 0 for i in range(0,iter_max)]


# step 3 : 迭代寻找最佳方案
while iter < iter_max:
    # 清除记录
    Visited = [[] for k in range(0,m)]   
    Solution = [[ 0 for j in range(0,n)] for k in range(0,m) ]         
    print(iter,"......")
    # 计算选择每一个物品的概率
    p = []
    for pi in range(0,n):
        t = (Tau[pi]**alpha)*(Eta[pi]**beta)
        accury = 10000
        p.append([pi,int(t*accury)])
    # 逐个蚂蚁选择物品
    for k in range(0,m):
        p_new = p[:]
        #print("init",p_new)
        # 逐个物品选择
        for j in range(0,n): 
            #print(j,p_new)
            sumP = sum(util.cutByCol(p_new,1))
            roulette = util.sumAdd(p_new)
            # 轮盘赌方式选择物品
            x = random.randint(0,sumP)
            index = util.selectOne(x,roulette)
            # 判断是否能装
            if util.canPutIn(Visited,w,c,p_new[index][0],Solution,k):
                Solution[k][p_new[index][0]] = 1
            else:
                Solution[k][p_new[index][0]] = 0
            # 记录选择过的物品
            Visited[k].append(p_new[index][0])
            # 抛去已经访问过的物品
            del p_new[index]

    # 求解每只蚂蚁的总价值量、背包所装总重量、所装东西的单位价值量
    total_v = [ 0 for i in range(0,m)]
    for i in range(0,m):
        for j in range(0,n):
            total_v[i] += v[j]*Solution[i][j]
    # 求解拥有最大价值的蚂蚁
    lmb = util.findMaxValue(Solution,v)
    iter_max_solution[iter] = Solution[lmb[0]]
    iter_maxV[iter] = lmb[1]
    if lmb[1] > maxV:
        maxV = lmb[1]
        global_solution = Solution[lmb[0]]
    print("max",lmb)
    # 计算 delta_tau 
    delta_tau = [ 0 for i in range(0,n)]
    for x in range(0,n):
        for y in range(0,m):
            diff = 0
            if Solution[y][x] == 1:
                diff = ( v[x] * Q ) / total_v[y]
            delta_tau[x] += diff
        # 更新信息素
        Tau[x] = (1-rho)*Tau[x] + delta_tau[x]

    iter += 1

print("maxV",maxV)
print("global_solution",global_solution)

# step 4 : 存储结果为CSV 
util.store('output.csv',iter_maxV,[maxV],global_solution)
        
