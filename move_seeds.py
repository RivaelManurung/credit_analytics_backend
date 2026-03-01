import os
import shutil

src_dir = "internal/data/schema/migrations"
dest_dir = "internal/data/schema/seeds"

if not os.path.exists(dest_dir):
    os.makedirs(dest_dir)

files = os.listdir(src_dir)

for file in files:
    if "seed" in file:
        # Example: 00039_seed_dummy_branches.sql
        # Clean: branches.sql
        name = file.replace("seed_dummy_", "").replace(".sql", "")
        # Remove prefix if exists: e.g., 00039_
        if "_" in name and name[: name.find("_")].isdigit():
            migration_num = name[: name.find("_")]
            clean_name = name[name.find("_") + 1 :]
            new_file = f"{clean_name}_{migration_num}.sql"
        else:
            new_file = f"{name}.sql"

        src_path = os.path.join(src_dir, file)
        dest_path = os.path.join(dest_dir, new_file)

        print(f"Moving {file} to {new_file}")
        shutil.move(src_path, dest_path)
