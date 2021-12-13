import csv
import re

def load(path):
    with open(path,'r') as f:
        f_csv = csv.reader(f)
        #print(f_csv)
        count = 0
        c = 0       # 背包容量
        n = 0       # 物品个数
        w = []      # w[i] 表示第i件物品的重量
        v = []      # v[i] 表示第i件物品的价值
        v_max = 0   # 最大价值总量
        res = []    # res[i]表示第i件物品是否选择
        pattern = re.compile(" ")
        for row in f_csv:
            if count == 0:
                pass
            elif count == 1:
                v_max = int(row[1])
                t = pattern.split(row[0])
                c,n = int(t[0]),int(t[1])
            else:
                wv = pattern.split(row[0])
                r = pattern.split(row[1])
                i = int(r[0]) - 1
                res.append(int(r[1]))
                w.append(int(wv[0]))
                v.append(int(wv[1]))
            count += 1
    return (c,n,v_max,w,v,res)
def store(path,c1,c2,c3):
    with open(path,'w') as f:
        f_csv = csv.writer(f)
        f_csv.writerow(c1)
        f_csv.writerow(c2)
        f_csv.writerow(c3)
def confirmData(tp):
    c,n,v_max,w,v,res = tp
    #print(c,n,v_max,w,v,res)
    sumW = 0
    sumV = 0
    for i in range(0,n):
        sumW += res[i]*w[i]
        sumV += res[i]*v[i]
    #print(sumW,sumV)
    if v_max == sumV and sumW <= c:
        return True
    return False
def sumAdd(p):
    sum = 0
    roulette = [ [p[i][0],p[i][1]] for i in range(0,len(p))]
    for i in range(0,len(roulette)):
        roulette[i][1] = roulette[i][1] + sum
        sum = roulette[i][1]
    return roulette
def selectOne(x,p):
    index = 0
    for item in p:
        if(x>item[1]):
            index += 1
            continue
        else:
            break
    return index
def cutByCol(p,n):
    col = []
    for item in p:
        col.append(item[n])
    return col
def canPutIn(Visited,w,c,current,Solution,k):
    curW = 0
    for i in Visited[k]:
        curW += w[i]*Solution[k][i]
    if c - curW >= w[current]:
        return True
    return False
def findMaxValue(Solution,v):
    maxV = 0
    antN = 0
    for i in range(len(Solution)):
        val = 0
        ant = Solution[i]
        for j in range(len(ant)):
            val += ant[j]*v[j]
        #print(val)
        if val > maxV:
            maxV = val
            antN = i
    return (antN,maxV)
def average(l):
    return sum(l)/len(l)
    
        
            
if __name__ == '__main__':
    #print(average([1,2,3,4,5]))
    #print(cutByCol([[1,2],[3,4]],1))
    #print(selectOne(95,sumAdd([[0,1],[1,3],[2,45],[3,43],[5,3],[6,23]])))
    #print(confirmData(load('/Users/liuyang/Desktop/knapsack-01-ant-colony/test-set/test.CSV ')))
    print(confirmData(load('../test-set/test.CSV')))
    #print(confirmData(load('../test-set/test3.CSV')))
    #print(confirmData(load('../test-set/test4.CSV')))
    #print(confirmData(load('../test-set/test5.CSV')))
    #print(confirmData(load('../test-set/test6.CSV')))
    #print(confirmData(load('../test-set/test7.CSV')))
    #print(confirmData(load('../test-set/test8.CSV')))
    #print(confirmData(load('../test-set/test9.CSV')))
    #print(confirmData(load('../test-set/test10.CSV')))
    #print(confirmData(load('../test-set/test11.CSV')))
    #print(confirmData(load('../test-set/test12.CSV')))
    #print(confirmData(load('../test-set/test13.CSV')))
    #print(confirmData(load('../test-set/test14.CSV')))
