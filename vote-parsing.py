import csv

reps = []
dems = []

with open('data/house-votes-84.csv', newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
        party = row[0]
        votes = row[1:]

        if party == 'republican':
            reps.append(votes)
        else:
            dems.append(votes)

num_votes = len(reps[0])

def party_prototype(party_votes):
    prototype = []

    for j in range(num_votes):
        s = 0
        for person in party_votes:
            if person[j] == 'y':
                s += 1
            elif person[j] == 'n':
                s -= 1
            elif person[j] == '?':
                s += 0

        prototype.append(1 if s >= 0 else -1)

    return prototype

rep_pattern = party_prototype(reps)
dem_pattern = party_prototype(dems)

print("Republican prototype:", rep_pattern)
print("Democrat prototype:", dem_pattern)
