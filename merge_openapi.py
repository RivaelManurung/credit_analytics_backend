import os
import subprocess
import yaml

# List of proto files (relative to current directory)
proto_files = [
    "api/applicant/v1/applicant.proto",
    "api/application/v1/application.proto",
    "api/decision/v1/decision.proto",
    "api/financial/v1/financial.proto",
    "api/helloworld/v1/greeter.proto",
    "api/reference/v1/reference.proto",
    "api/survey/v1/survey.proto",
]

# Output directory for temporary files
temp_dir = "internal/server/generated_temp"
if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

# Final output file
output_file = "internal/server/openapi.yaml"

# Combined OpenAPI structure
combined_openapi = {
    "openapi": "3.0.3",
    "info": {"title": "Credit Analytics API", "version": "1.0.0"},
    "paths": {},
    "components": {"schemas": {}},
    "tags": [],
}

added_tags = set()

for proto in proto_files:
    # Use a unique directory for each proto's output
    proto_base = os.path.basename(proto).replace(".proto", "")
    target_dir = os.path.join(temp_dir, proto_base)
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    # Run protoc
    cmd = [
        "protoc",
        "--proto_path=./api",
        "--proto_path=./third_party",
        f"--openapi_out=fq_schema_naming=true,default_response=false:{target_dir}",
        proto,
    ]
    try:
        subprocess.run(cmd, check=True, capture_output=True, text=True)

        # Read the generated openapi.yaml
        gen_file = os.path.join(target_dir, "openapi.yaml")
        if os.path.exists(gen_file):
            with open(gen_file, "r") as f:
                data = yaml.safe_load(f)

                # Merge paths
                if "paths" in data:
                    combined_openapi["paths"].update(data["paths"])

                # Merge schemas
                if "components" in data and "schemas" in data["components"]:
                    combined_openapi["components"]["schemas"].update(
                        data["components"]["schemas"]
                    )

                # Merge tags
                if "tags" in data:
                    for tag in data["tags"]:
                        tag_name = tag["name"] if isinstance(tag, dict) else tag
                        if tag_name not in added_tags:
                            combined_openapi["tags"].append(
                                tag if isinstance(tag, dict) else {"name": tag}
                            )
                            added_tags.add(tag_name)
    except Exception as e:
        print(f"Error processing {proto}: {e}")

# Write combined OpenAPI
with open(output_file, "w") as f:
    yaml.dump(combined_openapi, f, sort_keys=False)

print(f"Successfully merged all OpenAPI definitions into {output_file}")
