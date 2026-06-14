cat > generator/generate.py << 'EOF'
import csv
import random
import os
import sys

NUM_ROWS = 100

COLUMNS = ["hero", "role", "kills", "deaths", "assists", "gpm", "xpm", "hero_damage", "win"]

HEROES = [
    "Pudge", "Invoker", "Juggernaut", "Phantom Assassin", "Anti-Mage",
    "Lion", "Crystal Maiden", "Drow Ranger", "Earthshaker", "Lina",
    "Shadow Fiend", "Sniper", "Storm Spirit", "Windranger", "Zeus",
    "Axe", "Bristleback", "Dragon Knight", "Omniknight", "Wraith King"
]

ROLES = ["Carry", "Mid", "Offlane", "Soft Support", "Hard Support"]

def generate_row():
    return {
        "hero": random.choice(HEROES),
        "role": random.choice(ROLES),
        "kills": random.randint(0, 25),
        "deaths": random.randint(0, 15),
        "assists": random.randint(0, 30),
        "gpm": random.randint(250, 850),
        "xpm": random.randint(200, 900),
        "hero_damage": random.randint(3000, 60000),
        "win": random.choice(["True", "False"]),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
EOF