
def multiplication(a, b):
    firstnumber = str(a)
    secondnumber = str(b)
    Multiplication = int(firstnumber, 2) * int(secondnumber, 2)
    return format(Multiplication, 'b')

print(multiplication(111, 101))