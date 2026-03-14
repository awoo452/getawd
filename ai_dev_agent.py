import subprocess
import os
from datetime import datetime
from openai import OpenAI

client = OpenAI()

CHANGELOG = "CHANGELOG.md"
BRANCH_BASE = "ai_dev_agent"


def branch_exists(name):
    return subprocess.call(
        ["git", "show-ref", "--verify", "--quiet", f"refs/heads/{name}"]
    ) == 0


def create_work_branch():
    if not branch_exists(BRANCH_BASE):
        branch_name = BRANCH_BASE
    else:
        date_suffix = datetime.now().strftime("%Y%m%d")
        branch_name = f"{BRANCH_BASE}-{date_suffix}"
        counter = 1
        while branch_exists(branch_name):
            branch_name = f"{BRANCH_BASE}-{date_suffix}-{counter}"
            counter += 1

    subprocess.check_call(["git", "checkout", "-b", branch_name])
    print("Created branch:", branch_name)

# -----------------------------
# create work branch
# -----------------------------

create_work_branch()

# -----------------------------
# get repository files
# -----------------------------

files = subprocess.check_output(["git","ls-files"]).decode().splitlines()

ignore = [
    "CHANGELOG.md",
    ".gitignore"
]

files = [f for f in files if f not in ignore]

if not files:
    print("No repo files found.")
    exit()

file_list = "\n".join(files[:40])

# -----------------------------
# AI selects file
# -----------------------------

selection_prompt = f"""
You are reviewing a software repository.

Choose ONE file that could benefit from a small improvement.

Allowed improvements:
- documentation
- readability
- comments
- small bug fixes
- README cleanup

Return ONLY the filename.

FILES:
{file_list}
"""

resp = client.responses.create(
    model="gpt-4.1",
    input=selection_prompt
)

target = resp.output_text.strip()

print("Selected file:", target)

if target not in files:
    print("Model returned invalid file. Aborting.")
    exit()

# -----------------------------
# read file
# -----------------------------

with open(target,"r") as f:
    original = f.read()

# -----------------------------
# AI improves file
# -----------------------------

improve_prompt = f"""
Improve this file slightly.

Rules:
- do not change functionality
- only readability or documentation
- return the FULL updated file
- no explanation

FILE:
{original}
"""

resp2 = client.responses.create(
    model="gpt-4.1",
    input=improve_prompt
)

updated = resp2.output_text

if updated.strip() == original.strip():
    print("No improvement made.")
    exit()

# -----------------------------
# write file
# -----------------------------

with open(target,"w") as f:
    f.write(updated)

print("File updated.")

# -----------------------------
# generate diff
# -----------------------------

diff = subprocess.check_output(["git","diff",target]).decode()

if not diff.strip():
    print("No diff detected.")
    exit()

# -----------------------------
# AI writes changelog entry
# -----------------------------

changelog_prompt = f"""
Write ONE changelog bullet describing this change.

Rules:
- 5 to 15 words
- no punctuation at start
- no explanation

DIFF:
{diff}
"""

resp3 = client.responses.create(
    model="gpt-4.1",
    input=changelog_prompt
)

entry = resp3.output_text.strip()

print("Changelog entry:", entry)

# -----------------------------
# insert into CHANGELOG
# -----------------------------

if not os.path.exists(CHANGELOG):
    with open(CHANGELOG,"w") as f:
        f.write("# Changelog\n\n## Unreleased\n")

with open(CHANGELOG,"r") as f:
    lines = f.readlines()

unreleased_index = None
for i, line in enumerate(lines):
    if line.strip().lower() == "## unreleased":
        unreleased_index = i
        break

if unreleased_index is None:
    lines = ["## Unreleased\n", "\n"] + lines
    unreleased_index = 0
elif unreleased_index != 0:
    end_index = unreleased_index + 1
    while end_index < len(lines):
        if lines[end_index].startswith("## ") and end_index != unreleased_index:
            break
        end_index += 1
    unreleased_section = lines[unreleased_index:end_index]
    del lines[unreleased_index:end_index]
    lines = unreleased_section + lines
    unreleased_index = 0

insert_index = unreleased_index + 1
if insert_index < len(lines) and lines[insert_index].strip() == "":
    insert_index += 1

lines.insert(insert_index, f"- {entry}\n")

next_index = insert_index + 1
scan_index = next_index
while scan_index < len(lines) and lines[scan_index].strip() == "":
    scan_index += 1

if scan_index < len(lines) and lines[scan_index].startswith("## "):
    if next_index >= len(lines) or lines[next_index].strip() != "":
        lines.insert(next_index, "\n")

with open(CHANGELOG,"w") as f:
    f.writelines(lines)

print("CHANGELOG updated.")
