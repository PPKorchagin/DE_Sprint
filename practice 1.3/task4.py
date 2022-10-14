from operator import le


openList = ["[", "{", "("]
closeList = ["]", "}", ")"]


def balance_check(myStr):
    stack = []
    for i in myStr:
        if i in openList:
            stack.append(i)
        elif i in closeList:
            pos = closeList.index(i)
            if (len(stack) > 0) and (openList[pos] == stack[len(stack) - 1]):
                stack.pop()
            else:
                return False        
    if len(stack) == 0:
        return True
    elif len(stack) == 1:
        return False

print(balance_check("[{}({})]"))
print(balance_check("{]"))
print(balance_check("{"))