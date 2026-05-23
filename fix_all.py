import sys

# ===== Fix 1: parser.gd:385 - remove \n conversion before translation =====
with open('d:/Pro/threekindom/addons/dialogue_manager/components/parser.gd', 'rb') as f:
    data = f.read()

old = b'\t\t\t\tline["text"] = line.text.replace("\\\\n", "\\n").strip_edges()'
new = b'\t\t\t\tline["text"] = line.text.strip_edges()'

count = data.count(old)
print(f'Fix 1: parser.gd:385 - old pattern found: {count}')
if count > 0:
    data = data.replace(old, new, 1)
    with open('d:/Pro/threekindom/addons/dialogue_manager/components/parser.gd', 'wb') as f:
        f.write(data)
    print('  DONE: parser.gd:385 fixed')
elif b'line.text.strip_edges()' in data:
    print('  OK: already fixed')
else:
    print('  FAIL: pattern not found')
    lines = data.split(b'\n')
    if len(lines) >= 385:
        print(f'  Line 385: {lines[384]}')

# ===== Fix 2: dialogue_manager.gd - add post-translation \n conversion =====
with open('d:/Pro/threekindom/addons/dialogue_manager/dialogue_manager.gd', 'rb') as f:
    dm = f.read()

# Check if already fixed
if b'markers.text.replace("\\\\n"' in dm:
    print('\nFix 2: dialogue_manager.gd - already has replace line, skipping')
else:
    marker = b'markers.text = resolved_text'
    idx = dm.find(marker)
    print(f'\nFix 2: dialogue_manager.gd - found markers.text at index {idx}')
    if idx >= 0:
        # Find indentation
        line_start = dm.rfind(b'\n', 0, idx) + 1
        indent = dm[line_start:idx]
        print(f'  Indentation: {len(indent)} tabs')

        line_end = dm.find(b'\n', idx)
        insert_pos = line_end + 1

        bs = b'\x5c'  # backslash
        n = b'\x6e'   # n
        new_line = indent + b'markers.text = markers.text.replace("' + bs + bs + n + b'", "' + bs + n + b'")\n'

        dm = dm[:insert_pos] + new_line + dm[insert_pos:]
        with open('d:/Pro/threekindom/addons/dialogue_manager/dialogue_manager.gd', 'wb') as f:
            f.write(dm)
        print('  DONE: dialogue_manager.gd fixed')
    else:
        print('  FAIL: markers.text = resolved_text not found')

# ===== Fix 3: CSV line 2172 - add [voice:zhubo_fenglushibai] to key =====
# The key in CSV is: 主公，本月俸禄未能按时足额发放，各部怨声渐起：{{allcontext}}府中钱粮紧张，若再不调度补给，恐生内乱。
# But the dialogue text has: 恐生内乱。[voice:zhubo_fenglushibai]
# So we need to add [voice:zhubo_fenglushibai] to the CSV key to match

print('\nFix 3: Checking CSV line 2172...')
with open('d:/Pro/threekindom/Asset/language/data.csv', 'rb') as f:
    csv_data = f.read()

# Check if voice tag already exists in line 2172
voice_marker = b'zhubo_fenglushibai'
if voice_marker in csv_data:
    print('  OK: voice tag already in CSV')
else:
    # Need to add [voice:zhubo_fenglushibai] to the key on line 2172
    # Find the key
    old_key = b'\xe4\xb8\xbb\xe5\x85\xac\xef\xbc\x8c\xe6\x9c\xac\xe6\x9c\x88\xe4\xbf\xb8\xe7\xa6\x84\xe6\x9c\xaa\xe8\x83\xbd\xe6\x8c\x89\xe6\x97\xb6\xe8\xb6\xb3\xe9\xa2\x9d\xe5\x8f\x91\xe6\x94\xbe\xef\xbc\x8c\xe5\x90\x84\xe9\x83\xa8\xe6\x80\xa8\xe5\xa3\xb0\xe6\xb8\x90\xe8\xb5\xb7\xef\xbc\x9a{{allcontext}}\xe5\xba\x9c\xe4\xb8\xad\xe9\x92\xb1\xe7\xb2\xae\xe7\xb4\xa7\xe5\xbc\xa0\xef\xbc\x8c\xe8\x8b\xa5\xe5\x86\x8d\xe4\xb8\x8d\xe8\xb0\x83\xe5\xba\xa6\xe8\xa1\xa5\xe7\xbb\x99\xef\xbc\x8c\xe6\x81\x90\xe7\x94\x9f\xe5\x86\x85\xe4\xb9\xb1\xe3\x80\x82'
    voice_tag = b'[voice:zhubo_fenglushibai]'
    new_key = old_key + voice_tag

    idx = csv_data.find(old_key)
    if idx >= 0:
        csv_data = csv_data[:idx] + new_key + csv_data[idx + len(old_key):]
        with open('d:/Pro/threekindom/Asset/language/data.csv', 'wb') as f:
            f.write(csv_data)
        print('  DONE: [voice:zhubo_fenglushibai] added to CSV key')
    else:
        print('  FAIL: Key not found in CSV')

print('\nAll fixes completed.')
