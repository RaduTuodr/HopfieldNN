import json

with open("data/test_exited.txt", "r") as f: # change to test_notexited for the non-exit clients
    vectors = json.load(f)

def get_haskell_syntax():
    for vector in vectors:
        print("(", end="")
        for i in range(len(vector)):
            print(f"{vector[i]} :>", end=" ")
        print(f"Nil) :> ")
    print(f"Nil", end="")

get_haskell_syntax()