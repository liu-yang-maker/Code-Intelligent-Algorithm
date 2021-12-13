import csv
with open('./test1.CSV','r') as f:
    f_csv = csv.reader(f)
    for row in f_csv:
        print(row)

data = util.load('../test-set/test1.CSV')
print(data)
