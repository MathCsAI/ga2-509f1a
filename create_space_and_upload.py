#!/usr/bin/env python3
import os
import textwrap
from pathlib import Path
from huggingface_hub import HfApi

HF_TOKEN = os.environ.get("HF_TOKEN")
HF_USER = os.environ.get("HF_USER")  # your HF username
SPACE_NAME = "ga2-509f1a"
REPO_ID = f"{HF_USER}/{SPACE_NAME}"

if not HF_TOKEN or not HF_USER:
    raise SystemExit("Please set HF_TOKEN and HF_USER as environment variables before running.")

api = HfApi(token=HF_TOKEN)

# Create the space repo (public, Docker SDK, CPU Basic).
# If the huggingface_hub version does not accept space_hardware, upgrade huggingface_hub to the latest.
try:
    api.create_repo(
        repo_id=REPO_ID,
        repo_type="space",
        private=False,
        space_sdk="docker",
        space_hardware="cpu-basic",
        exist_ok=True
    )
    print("Created or verified space:", REPO_ID)
except Exception as e:
    print("Warning while creating space (might already exist):", e)

# Upload all files from current repo folder to the new Space
# We'll upload the files in the current checked-out repo folder.
folder_to_upload = Path.cwd()

try:
    api.upload_folder(repo_id=REPO_ID, repo_type="space", folder_path=str(folder_to_upload))
    print("Uploaded files to", REPO_ID)
except Exception as e:
    print("upload_folder failed:", e)

print("Next: go to the Space on Hugging Face and add the secret GA2_TOKEN_0DBE in Settings → Secrets.")
print("When the Space builds, you'll find it at: https://huggingface.co/spaces/{}/{}".format(HF_USER, SPACE_NAME))

