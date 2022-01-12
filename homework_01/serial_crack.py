import random
import string
import math

max_symb = 'z'
min_symb = '!'

def hash_by_name(name):
    hash_val = sum(ord(x) for x in name) ^ 0x5678
    hash_val &= 0xFFFFFFFF
    return hash_val ^ 0x1234

def val_update(val, sym):
    return (val * 0xA) + ord(sym) - 0x30

def generate_name(length=4):
    letters = random.choices(string.ascii_uppercase, k=length)
    return "".join(letters)

def generate_serial_by_name(name):
    hash_name = hash_by_name(name)
    letters = list()
    while hash_name > 0:
        letters.append((hash_name % 0xA) + 0x30)
        hash_name //= 0xA
    return reversed(letters)

def generate_serial(name):
    serial_list = generate_serial_by_name(name)
    assert serial_list is not None
    return "".join([chr(x) for x in serial_list])

def check_serial(name, serial):
    edi = 0
    for x in serial:
        edi = val_update(edi, x)
    return edi == hash_by_name(name)

if __name__ == "__main__":
    max_tries = 10
    serial = "/"
    print("Generating name and serial for CRACKME.EXE...")
    name = generate_name()
    serial = generate_serial(name)
    while not check_serial(name, serial) and max_tries > 0:
        name = generate_name()
        serial = generate_serial(name)
        max_tries -= 1

    print("name:", name) 
    print("serial number:", serial)
