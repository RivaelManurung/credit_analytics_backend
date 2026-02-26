import re

with open("internal/data/schema/seed_dummy.sql", "r", encoding="utf-8") as f:
    data = f.read()


def replace_opt(m):
    return (
        m.group(1)
        + "(SELECT id FROM custom_column_attribute_registries WHERE attribute_code = '"
        + m.group(2)
        + "')"
        + m.group(3)
    )


start_opt = data.find("INSERT INTO attribute_options")
if start_opt != -1:
    end_opt = data.find("INSERT INTO", start_opt + 10)
    if end_opt == -1:
        end_opt = len(data)
    block = data[start_opt:end_opt]
    block = re.sub(r"(\(\s*)'([a-z_0-9]+)'(\s*,)", replace_opt, block)
    data = data[:start_opt] + block + data[end_opt:]


def replace_app_attr(m):
    return (
        m.group(1)
        + "(SELECT id FROM custom_column_attribute_registries WHERE attribute_code = '"
        + m.group(2)
        + "')"
        + m.group(3)
    )


start_app = data.find("INSERT INTO applicant_attributes")
if start_app != -1:
    end_app = data.find("INSERT INTO", start_app + 10)
    if end_app == -1:
        end_app = len(data)
    block = data[start_app:end_app]
    # The string values are in the second parameter of values.
    # Pattern: ( 'some-uuid-string' , 'attr_code' ,
    block = re.sub(
        r"(\(\s*'[^']+'\s*,\s*)'([a-z_0-9]+)'(\s*,)", replace_app_attr, block
    )
    data = data[:start_app] + block + data[end_app:]

with open("internal/data/schema/seed_dummy.sql", "w", encoding="utf-8") as f:
    f.write(data)
print("Done")
