
x=10
y=20
a=40
b=80

if x < y:
    for i in range(10):
        print ("Hello, world!")
else:
    print ("Goodbye, world!")

if a > b:
    print ("X is bigger than Y")
elif a < b:
    print ("Y is bigger than X")
else: 
    print ("X and Y are ")



def sum(arr):
 
    sum = 0

    for i in arr:
        sum = sum + i
 
    return(sum)
 
 
